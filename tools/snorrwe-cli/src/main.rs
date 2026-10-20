use std::{
    ffi::OsString,
    path::{Path, PathBuf},
};

use anyhow::Context as _;
use clap::Parser;
use clap_derive::{Parser, Subcommand};

#[derive(Debug, Parser)]
#[command(version, about = "snorrwe specific workflow support tool")]
struct Args {
    #[command(subcommand)]
    cmd: Commands,
}

#[derive(Debug, Subcommand, Clone)]
enum Commands {
    /// Setup a typical project workspace
    #[command()]
    SetupWorkspace {
        #[arg()]
        git_url: String,
        #[arg(default_value = "./")]
        destination: PathBuf,
        #[arg(short, long)]
        devenv_url: Option<String>,
        #[arg(short, long, allow_hyphen_values = true, num_args = 1)]
        gitargs: Vec<OsString>,
        /// If the destination exists, delete it
        #[arg(short, long, default_value_t = false)]
        force: bool,
    },
}

fn clone_workspace(
    destination: &Path,
    git_url: &str,
    devenv_url: Option<&str>,
    gitargs: &[OsString],
) -> anyhow::Result<()> {
    let sh = xshell::Shell::new()?;
    let wt = destination.join("worktrees");
    std::fs::create_dir_all(&wt)?;
    if let Some(git_url) = devenv_url {
        sh.change_dir(destination);
        xshell::cmd!(sh, "git clone {gitargs...} {git_url}").run()?;
    }
    sh.change_dir(wt);
    xshell::cmd!(sh, "git clone {gitargs...} {git_url}").run()?;

    Ok(())
}

fn main() -> anyhow::Result<()> {
    let args = Args::parse();

    match args.cmd {
        Commands::SetupWorkspace {
            git_url,
            devenv_url,
            destination,
            gitargs,
            force,
        } => {
            let destination = std::path::absolute(destination)?;
            let exists = match std::fs::symlink_metadata(&destination) {
                Ok(_) => true,
                Err(e) if e.kind() == std::io::ErrorKind::NotFound => false,
                Err(e) => return Err(e.into()),
            };

            if force && exists {
                let parent = destination
                    .parent()
                    .context("Cannot replace the filesystem root")?;
                let staging = tempfile::tempdir_in(parent)?;
                let new = staging.path().join("new");
                let old = staging.path().join("old");
                clone_workspace(&new, &git_url, devenv_url.as_deref(), &gitargs)?;

                std::fs::rename(&destination, &old)?;
                if let Err(e) = std::fs::rename(&new, &destination) {
                    if let Err(rollback) = std::fs::rename(&old, &destination) {
                        let saved = staging.keep();
                        anyhow::bail!(
                            "Failed to install workspace ({e}) and restore original ({rollback}); original is at {}",
                            saved.join("old").display()
                        );
                    }
                    Err(e)?;
                }
                staging.close()?;
            } else {
                clone_workspace(&destination, &git_url, devenv_url.as_deref(), &gitargs)?;
            }
        }
    }
    Ok(())
}

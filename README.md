# Dotfile

## Setup

```sh
git clone https://github.com/snorrwe/dotfiles $HOME/.dotfiles --branch main
cd $HOME/.dotfiles
git submodule update --init --recursive
./install.sh danipc
```

Make sure you have flakes enabled.
In `configuration.nix`

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

### Updating

My usual workflow is

- Update system proper

  ```sh
  just update
  ```

- Reboot

- Update the rest of the system

  ```sh
  topgrade
  ```

The reason being NVIDIA driver updates. If updating flatpaks and the system in the same session, sometimes the NVIDIA drivers get out of sync and I find that some programs do not tolerate that well.

## Agent container (NixOS)

The `enableAgents` feature on NixOS creates a rootless podman container called `agent-box` to run AI agents with some isolation. It bind-mounts `dotfiles.agents.sharedDirectories` and the host Nix store and daemon socket. Both NixOS hosts share this checkout and `~/Projects`; `danipc` also shares `/mnt/data-0`. The launcher uses the current directory as the workdir when it lies inside one of those mounts, and rejects other directories. `agent-box --no-cwd` starts in `/home/agent`. The repo's standalone `homeConfigurations.agent` installs CLI tools and configs into that persistent home; it does not mount the host's Home Manager profile or credentials. Use the command with the same name to enter the container. `agent-box --attach` opens another shell in the running box and leaves its mounts unchanged.

A normal launch leaves a running box alone when its configuration has changed. Stop it with `podman stop agent-box`, then run `agent-box` again. Recreation preserves the home volume and discards root-filesystem changes, including manually installed Fedora packages. The next launch reinstalls Fedora `sudo` and `uv`.

The host Nix daemon socket is shared so Nix builds use the host store. A read-only socket mount does not restrict daemon requests: the host daemon's user permissions still apply. Writable workspaces can be modified or deleted by the agent. Boxes use pasta, and `agent-box-egress` rejects new connections from the `agent-box` group to private, link-local, and Tailscale addresses. Public internet egress stays open. A raw `podman start` leaves pasta in the user's normal group, so that filter misses it. Treat this as isolation for routine agent work, not as a security sandbox.

## Setup on non-Nixos system

- Install Nix
- Configure Nix

    ```ini
    # /etc/nix/nix.conf
    experimental-features = nix-command flakes
    # ...
    ```

- Apply the configuration `./install-hm.sh`

## Setup on macOS

Uses plain home-manager (no nix-darwin / system-level management).

- Install Nix (e.g. via the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) or the official installer)
- Configure Nix

    ```ini
    # /etc/nix/nix.conf
    experimental-features = nix-command flakes
    ```

- Clone the repo as above
- First-time install: `./install-darwin.sh`
- After that, updates go through `just darwin-apply`

## Adding secrets

See commit 5613beba3186 Setup sccache with the local garage storage

Add the file to ./modules/secrets/agenix-rules.nix

Use `just edit-secret <name>` to edit its contents

Use it in a nixos module as shown.

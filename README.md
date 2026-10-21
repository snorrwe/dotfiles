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

The `enableAgents` feature on NixOS creates a rootless podman container called `agent-box` to run AI agents with some isolation. They get the declared workspace mounts (including ~/Projects), the current dir, and the host Nix store and daemon. The repo's standalone `homeConfigurations.agent` installs CLI tools and configs into the persistent `/home/agent` home; it does not mount the host's Home Manager profile or credentials. Use the command with the same name to enter the container. Use `agent-box --attach` for another shell in the existing box without changing its mounts.

When migrating an existing box to Home Manager, stop it explicitly with `podman stop agent-box` (and `agent-box-gui` if used), then run `agent-box` again. Recreation preserves the home volume but discards root-filesystem changes, including manually installed Fedora packages. Home Manager backs up conflicting home files with `.before-home-manager` and aborts if a backup already exists.

The host Nix daemon socket is shared so Nix builds use the host store. A read-only socket mount does not restrict daemon requests: the host daemon's user permissions still apply. Writable workspaces can be modified or deleted by the agent. This is not a network or GUI security sandbox.

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

Add the file to ./modules/secrets/secrets.nix

Use `just edit-secret <name>` to edit its contents

Use it in a nixos module as shown.

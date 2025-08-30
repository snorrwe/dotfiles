# Setup

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

## Updating

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

# Setup on non-Nixos system

- Install Nix
- Configure Nix

    ```ini
    # /etc/nix/nix.conf
    experimental-features = nix-command flakes
    # ...
    ```

- Apply the configuration `./install-hm.sh`

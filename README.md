# Setup

```sh
git clone https://github.com/snorrwe/dotfiles $HOME/.dotfiles
cd $HOME/.dotfiles
nix-shell -p just --run 'just install danilife'
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

# Setup

Install [GNU Stow](https://www.gnu.org/software/stow/)

```sh
pacman -S stow
```

```sh
git clone https://github.com/snorrwe/dotfiles $HOME/.dotfiles
cd $HOME/.dotfiles
stow --adopt .
```

If checkout fails with file exists then backup and delete those.

# Install stuff

```sh
bash .setup/setup.sh
```

Assumes you have `pacman` and `bash`

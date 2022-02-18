# Setup

```
echo ".cfg" >> .gitignore
git clone --bare https://github.com/snorrwe/dotfiles $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
```

If checkout fails with file exists then backup and delete those.

# Install stuff

```
sudo bash install.sh
```

Assumes you have `apt` and `bash` installed

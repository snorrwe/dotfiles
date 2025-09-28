default_host := "${NIX_HOST}"

default:
    just --list

clean:
    nh clean all --keep-since 4d --keep 3 --nogcroots

update *args:
    nix flake update
    git add flake.lock
    git commit -m "System update $(printf '%(%Y-%m-%d)T\n' -1)"
    just apply {{ args }}

apply hostname=default_host: && apply-stow
    nh os switch "." --hostname={{ hostname }}

apply-stow:
    stow --adopt --dotfiles .

# apply home-manager config
apply-hm: && apply-stow
    nh home switch .

install hostname=default_host: && setup-git-hooks
    mkdir -p "./hosts/{{ hostname }}"
    sudo nixos-generate-config --show-hardware-config > "./hosts/{{ hostname }}/hardware.nix"

    just apply {{ hostname }}

# clears zsh-snap eval cache

# use when you get errors like _xyz_hook:2: no such file or directory: /nix/store/...
clean-zsh-cache:
    rm -rf ~/.cache/zsh-snap

setup-git-hooks:
    rm -rf .git/hooks
    ln -s "$PWD/.githooks" ./.git/hooks

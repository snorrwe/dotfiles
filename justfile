hostname := env("NIX_HOST")

default:
    just --list

clean:
    nh clean all --nogcroots

update *args:
    nix flake update
    git add flake.lock
    git commit -m "System update $(date +%F)"
    just apply {{ args }}

apply *args:
    nh os switch "." --hostname={{ hostname }} {{ args }}

# apply home-manager config
hm-apply *args:
    nh home switch . {{ args }}

generate-hardware-config:
    mkdir -p "./hosts/{{ hostname }}"
    sudo nixos-generate-config --show-hardware-config > "./hosts/{{ hostname }}/hardware.nix"

install: generate-hardware-config && setup-git-hooks
    just apply {{ hostname }}

# clears zsh-snap eval cache use when you get errors like _xyz_hook:2: no such file or directory: /nix/store/...
clean-zsh-cache:
    rm -rf ~/.cache/zsh-snap

setup-git-hooks:
    rm -rf .git/hooks
    ln -s "$PWD/.githooks" ./.git/hooks

lint:
    statix check

# builds the config and sets it as the boot default - but does not switch
boot *args:
    nh os boot '.' --hostname={{ hostname }} {{ args }}

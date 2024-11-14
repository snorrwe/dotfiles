default_host := "${NIX_HOST}"

default:
    just --list

# clean the system of unwanted caches
clean: clean-generations gc

clean-generations n="+2":
    sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system {{n}}
    sudo /run/current-system/bin/switch-to-configuration boot

gc: nix-gc devenv-gc

nix-gc:
    nix-collect-garbage -d

devenv-gc:
    devenv gc


update *args:
    #!/usr/bin/env bash
    set -euo pipefail

    nix flake update
    git add flake.lock
    git commit -m "System update $(printf '%(%Y-%m-%d)T\n' -1)"
    just apply {{args}}

apply hostname=default_host:
    #!/usr/bin/env bash
    set -euo pipefail

    sudo nixos-rebuild switch --flake ".#{{hostname}}"
    stow --adopt .

install hostname=default_host:
    mkdir -p "./hosts/{{hostname}}"
    sudo nixos-generate-config --show-hardware-config > "./hosts/{{hostname}}/hardware.nix"

    just apply {{hostname}}

# clears zsh-snap eval cache
# use when you get errors like _xyz_hook:2: no such file or directory: /nix/store/...
clean-zsh-cache:
    rm -rf ~/.cache/zsh-snap

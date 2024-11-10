default:
    just --list

clean: clean-generations gc

clean-generations n="+2":
    sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system {{n}}
    sudo /run/current-system/bin/switch-to-configuration boot

gc: nix-gc devenv-gc

nix-gc:
    nix-collect-garbage -d

devenv-gc:
    nix-collect-garbage -d


update *args:
    #!/usr/bin/env bash
    set -euo pipefail

    nix flake update
    git add flake.lock
    git commit -m "System update $(printf '%(%Y-%m-%d)T\n' -1)"
    just apply {{args}}

apply hostname=`echo $NIX_HOST`:
    #!/usr/bin/env bash
    set -euo pipefail

    sudo nixos-rebuild switch --flake ".#{{hostname}}"
    stow --adopt .

install hostname=`echo $NIX_HOST`:
    mkdir -p "./hosts/{{hostname}}"
    sudo nixos-generate-config --show-hardware-config > "./hosts/{{hostname}}/hardware.nix"

    just apply {{hostname}}

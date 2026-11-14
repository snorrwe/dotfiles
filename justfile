hostname := env("NIX_HOST", "NOHOSTSET")

default:
    just --list

clean:
    nh clean all --nogcroots

update-flake:
    nix flake update
    git add flake.lock
    git commit -m "System update $(date +%F)"

update *args: update-flake (apply args)

apply *args:
    nh os switch "." --hostname={{ hostname }} {{ args }}

# apply home-manager config
hm-apply *args:
    nh home switch . {{ args }}

# apply home-manager config on macOS, targets the config explicitly
# (no need to rename the Mac to match)
darwin-apply *args:
    nh home switch . -c dkiss@danimac {{ args }}

generate-hardware-config:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p "./modules/hosts/{{ hostname }}"
    tmp="$(mktemp)"
    sudo nixos-generate-config --show-hardware-config >"$tmp"
    {
      printf '{\n  flake.modules.nixos.{{ hostname }} =\n'
      cat "$tmp"
      printf ';\n}\n'
    } >"./modules/hosts/{{ hostname }}/hardware.nix"
    rm -f "$tmp"

install: generate-hardware-config && setup-git-hooks
    just apply {{ hostname }}

install-darwin: setup-git-hooks
    just darwin-apply

setup-git-hooks:
    rm -rf .git/hooks
    ln -s "$PWD/.githooks" ./.git/hooks

lint:
    statix check

# builds the config and sets it as the boot default - but does not switch
boot *args:
    nh os boot '.' --hostname={{ hostname }} {{ args }}

render-dotfiles out="/tmp/hm-render":
    nix build .#homeConfigurations.snorrwe.activationPackage -o {{ out }}

agenix *args:
    cd ./modules/_secrets && nix run github:ryantm/agenix -- {{ args }}

edit-secret name: (agenix "-e" name)

list-secrets:
    @find modules/_secrets -type f -not -name agenix-rules.nix -exec basename {} \;

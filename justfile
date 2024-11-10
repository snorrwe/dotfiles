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

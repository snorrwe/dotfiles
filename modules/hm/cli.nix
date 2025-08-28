{
  pkgs,
  lib,
  username,
  ...
}:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.eza = {
    enable = true;
    git = true;
  };

  programs.fd = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  # colorful, syntax highlighted cat alternative
  programs.bat = {
    enable = true;
    config = {
      theme = "Coldark-Dark";
    };
  };

  home.activation.setupSnap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    out="/home/${username}/.local/share/zsh-snap"
    if [[ ! -d $out ]]; then
        rm -f "$out"
        mkdir -p $(dirname "$out")
        ${pkgs.git}/bin/git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git "$out"
    fi
  '';
}

{
  flake.modules.homeManager.gui =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      home.packages = with pkgs; [
        libnotify
        (writeScriptBin "niri-fuzzel-select-window" (builtins.readFile ./scripts/niri-fuzzel-select-window))
      ];

      programs = {
        wezterm = {
          enable = true;
          enableZshIntegration = true;
          extraConfig = builtins.readFile ../../dotfiles/.wezterm.lua;
          package = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };

        # media player, used by yazi by default
        mpv = {
          enable = true;
        };
      };
    };
}

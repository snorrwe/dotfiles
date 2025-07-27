{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableZshIntegration = true;
    plugins = with pkgs.yaziPlugins; {
      starship = starship;
    };
    initLua = ''
      require("starship"):setup()
    '';
    settings = {
      mgr = {
        show_hidden = true;
        sort_dir_first = true;
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "<C-s>" ];
          run = ''shell "$SHELL" --block --confirm'';
          desc = "Open shell here";

        }
        {
          on = [ "y" ];
          run = [
            ''
              	shell 'echo "$@" | xclip -i -selection clipboard -t text/uri-list' --confirm
            ''
            "yank"
          ];
        }
      ];
    };
  };
}

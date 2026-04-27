{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableZshIntegration = true;
    plugins = with pkgs.yaziPlugins; {
      inherit mount starship;
    };
    initLua = ''
      require("starship"):setup()
    '';
    settings = {
      mgr = {
        show_hidden = true;
        sort_dir_first = true;
        sort_by = "natural";
        sort_reverse = true;
        show_symlink = true;
        linemode = "mtime";
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
        {
          on = [ "M" ];
          run = [ "plugin mount" ];
        }
      ];
    };
  };
}

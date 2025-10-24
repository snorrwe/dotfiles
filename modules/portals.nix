{ pkgs, ... }:
let
  # TODO: configure term e.g. via TERMCMD env var?
  yazi-wrapper = pkgs.writeScriptBin "yazi_xdg_wrapper" ''
    set -exuo pipefail

    cmd="${pkgs.yazi}/bin/yazi"
    multiple="$1"
    directory="$2"
    save="$3"
    path="$4"
    out="$5"
    export DISPLAY=":0"
    termcmd="wezterm start --always-new-process --class 'wezterm.termfilechooser'"

    if [ "$save" = "1" ]; then
        # save a file
        set -- --chooser-file="$out" "$path"
    elif [ "$directory" = "1" ]; then
        # upload files from a directory
        set -- --chooser-file="$out" --cwd-file="$out" "$path"
    elif [ "$multiple" = "1" ]; then
        # upload multiple files
        set -- --chooser-file="$out" "$path"
    else
        # upload only 1 file
        set -- --chooser-file="$out" "$path"
    fi

    command="$termcmd $cmd"
    for arg in "$@"; do
        # escape double quotes
        escaped=$(printf "%s" "$arg" | sed 's/"/\\"/g')
        # escape spaces
        command="$command \"$escaped\""
    done
    sh -c "$command"
  '';
in
{
  environment.systemPackages = [ yazi-wrapper ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      gnome-keyring
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-termfilechooser # Portal for using TUIs as file pickers
    ];
    config = {
      common = {
        default = [
          "termfilechooser"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = "wlr"; # NOTE: This is required for screensharing to work properly
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
    };
  };
}

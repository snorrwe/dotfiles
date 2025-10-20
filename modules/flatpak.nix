# from https://www.reddit.com/r/NixOS/comments/1hzgxns/fully_declarative_flatpak_management_on_nixos/
{ features, pkgs, ... }:
let
  inherit (pkgs.lib.lists) optionals;
in
{
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
    packages = [
      "flathub:app/org.cloudcompare.CloudCompare//stable"
      "flathub:app/org.videolan.VLC//stable"
      "flathub:app/org.blender.Blender//stable"
      "flathub:app/net.meshlab.MeshLab//stable"
      "flathub:app/org.kde.krita//stable"
      "flathub:app/com.discordapp.Discord//stable"
      "flathub:app/com.spotify.Client//stable"
      "flathub:app/org.telegram.desktop//stable"
      "flathub:app/com.bitwarden.desktop//stable"
      "flathub:app/org.mozilla.Thunderbird//stable"
      "flathub:app/com.slack.Slack//stable"
      "flathub:app/md.obsidian.Obsidian//stable"
      "flathub:app/com.jgraph.drawio.desktop//stable"
      "flathub:app/com.obsproject.Studio//stable"
      "flathub:app/app.zen_browser.zen//stable"
      "flathub:app/org.chromium.Chromium//stable"
      "flathub:app/dev.restfox.Restfox//stable"
      "flathub:app/be.alexandervanhee.gradia//stable"
      "flathub:app/org.libreoffice.LibreOffice//stable"
    ]
    ++ optionals features.enableGaming [
      "flathub:app/com.heroicgameslauncher.hgl//stable"
    ];
  };
}

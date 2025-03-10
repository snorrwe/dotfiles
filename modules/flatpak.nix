# from https://www.reddit.com/r/NixOS/comments/1hzgxns/fully_declarative_flatpak_management_on_nixos/
{ pkgs, ... }:

let
  # We point directly to 'gnugrep' instead of 'grep'
  grep = pkgs.gnugrep;

  # 1. Declare the Flatpaks you *want* on your system
  desiredFlatpaks = [
    "org.cloudcompare.CloudCompare"
    "org.videolan.VLC"
    "org.blender.Blender"
    "net.meshlab.MeshLab"
    "us.zoom.Zoom"
    "org.kde.krita"
    "com.discordapp.Discord"
    "com.spotify.Client"
    "org.telegram.desktop"
    "com.bitwarden.desktop"
    "org.mozilla.Thunderbird"
    "com.slack.Slack"
    "md.obsidian.Obsidian"
    "com.jgraph.drawio.desktop"
    "com.obsproject.Studio"
    "app.zen_browser.zen"
    "org.chromium.Chromium"
  ];
in
{
  system.activationScripts.flatpakManagement = {
    text = ''
      # 2. Ensure the Flathub repo is added
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo

      # 3. Get currently installed Flatpaks
      installedFlatpaks=$(${pkgs.flatpak}/bin/flatpak list --app --columns=application)

      # 4. Remove any Flatpaks that are NOT in the desired list
      for installed in $installedFlatpaks; do
        if ! echo ${toString desiredFlatpaks} | ${grep}/bin/grep -q $installed; then
          echo "Removing $installed because it's not in the desiredFlatpaks list."
          ${pkgs.flatpak}/bin/flatpak uninstall -y --noninteractive $installed
        fi
      done

      # 5. Install or re-install the Flatpaks you DO want
      ${pkgs.flatpak}/bin/flatpak install -y flathub ${toString desiredFlatpaks}
    '';
  };
}

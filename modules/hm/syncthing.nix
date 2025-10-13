{ username, ... }:
{
  services.syncthing = {
    enable = true;
    user = username;
    configDir = "/home/${username}/.config/syncthing";
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      folders.notes = {
        enable = true;
        path = "/home/${username}/notes";
        devices = [
          "home-1"
        ];
      };
      devices = {
        "home-1" = {
          id = "WOFQZAN-6GWHQWU-IL2UDKR-BGWLMB6-2VKZHZR-YJJ4GNS-WSVWGQS-4WB4RQK";
          name = "home-1";
        };
      };
    };
  };
}

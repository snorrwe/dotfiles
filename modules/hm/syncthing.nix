{ username, ... }:
{
  services.syncthing = {
    enable = true;
    user = username;
    configDir = "/home/${username}/.config/syncthing";
    settings = {
      folders.notes = {
        enable = true;
        path = "/home/${username}/notes";
      };
    };
  };
}

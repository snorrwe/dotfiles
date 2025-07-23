{ pkgs, ... }:
{

  virtualisation = {
    docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings = {
          features.cdi = true;
        };
      };
    };
    podman = {
      enable = true;
    };
    containers = {
      registries = {
        insecure = [ "docker.local:5000" ];
      };
    };
  };
}

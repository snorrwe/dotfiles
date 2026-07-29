_: {

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
    containers.registries.settings = {
      insecure = [ "docker.local:5000" ];
    };
  };
}

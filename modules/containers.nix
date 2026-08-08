_:
let
  insecureRegistries = [
    "docker.local:5000"
  ];
in
{
  virtualisation = {
    docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings = {
          features.cdi = true;
          # Docker ignores /etc/containers/registries.conf, it needs its own
          # daemon.json entry to allow plain HTTP to the local registry.
          insecure-registries = insecureRegistries;
        };
      };
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    podman = {
      enable = true;
    };
    containers.registries.settings = {
      registry = [
        {
          location = "docker.io";
        }
        {
          location = "quay.io";
        }
      ]
      ++ map (location: {
        inherit location;
        insecure = true;
      }) insecureRegistries;
    };
  };
}

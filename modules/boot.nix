{
  flake.modules.nixos.common =
    { config, pkgs, ... }:
    {
      boot = {
        loader.timeout = 2;
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;

        kernelPackages = pkgs.linuxPackages_zen;
        # OBS Virtual Cam
        kernelModules = [ "v4l2loopback" ];
        extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

        tmp = {
          useTmpfs = false;
          tmpfsSize = "30%";
        };

        # Appimage Support
        binfmt.registrations.appimage = {
          wrapInterpreterInShell = false;
          interpreter = "${pkgs.appimage-run}/bin/appimage-run";
          recognitionType = "magic";
          offset = 0;
          mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
          magicOrExtension = "\\x7fELF....AI\\x02";
        };

        plymouth.enable = true;
      };
    };
}

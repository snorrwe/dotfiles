{ config
, pkgs
, host
, username
, ...
}:
let
  defaultBrowser = "app.zen_browser.zen";
in

{
  imports = [
    ./hardware.nix
    ./sound.nix
    ./video.nix
    ./udev.nix
    ../../commit-message.nix
    ../../modules/git.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "10m";
  };

  # Bootloader.
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Make /tmp a tmpfs
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
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  networking.hostName = host;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.direnv = {
    package = pkgs.direnv;
    silent = false;
    loadInNixShell = true;
    direnvrcExtra = "";
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez5-experimental;
    settings.Policy.AutoEnable = "true";
    settings.General.Enable = "Source,Sink,Media,Socket";
  };
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.snorrwe = {
    isNormalUser = true;
    description = "Dani";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    createHome = true;
    packages =
      with pkgs;
      [
        pavucontrol
        pamixer
        pulseaudio
        flameshot
      ]
      ++ (import ../../modules/common-packages.nix pkgs);
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;

  };
  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        insecure-registries = [
          "docker.local:5000"
        ];
      };
    };
  };
  virtualisation.podman = {
    enable = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  services.flatpak.enable = true;

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      monaspace
      cascadia-code
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    stow
    parallel
    curl
    fzf
    yazi
    python3
    xdg-desktop-portal
    networkmanagerapplet
    gnome-keyring
    xorg.xhost
    sshfs
    xclip
    linuxKernel.packages.linux_zen.perf
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font = "Monaspace Radon";
      fontSize = "13";
      background = "${../../wallpaper.jpg}";
      loginBackground = true;
    })
  ];
  programs.npm.enable = true;
  environment.variables.RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  xdg.portal = {
    enable = true;
    config.common.default = [ "gtk" ];
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
  # set default browser
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = defaultBrowser;
      "x-scheme-handler/http" = defaultBrowser;
      "x-scheme-handler/https" = defaultBrowser;
      "x-scheme-handler/about" = defaultBrowser;
      "x-scheme-handler/unknown" = defaultBrowser;
    };
  };
  environment.sessionVariables.DEFAULT_BROWSER = defaultBrowser;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.shellInit = ''
    [ -n "$DISPLAY" ] && xhost +si:localuser:$USER >/dev/null || true
  '';

  #Flakes
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      trusted-users = root ${username}
      experimental-features = nix-command flakes
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 39420 ];
  };
  # certain elements in my life might press the button while I'm working :)
  services.logind.powerKey = "ignore";

  services.earlyoom = {
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

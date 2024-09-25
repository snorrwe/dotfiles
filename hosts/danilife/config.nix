{ config
, pkgs
, host
, username
, options
, inputs
, ...
}:

{
  imports = [
    ./hardware.nix
    ./sound.nix
    ./commit-message.nix
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
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

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';


  networking.hostName = "danilife"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez5-experimental;
    settings.Policy.AutoEnable = "true";
    settings.General.Enable = "Source,Sink,Media,Socket";
  };
  services.blueman.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.snorrwe = {
    isNormalUser = true;
    description = "Dani";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      pavucontrol
      xfce.thunar
      thunderbird
      wezterm
      wofi
      tmux
      stow
      parallel
      unzip
      zip
      dust
      atuin
      llvm
      clang
      mold
      fd
      ripgrep
      zoxide
      wl-clipboard
      rustup
      go
      just
      watchexec
      grimblast
      sccache
      lazygit
      ninja
      starship
      flatpak
      pipx
      bat
      btop
      waybar
      cmake
      gzip
      diffutils
      github-cli
      direnv
      git-lfs
      socat
      jq
      obsidian
      slack
      telegram-desktop
      discord
      spotify
      bluez5-experimental
      bluez-tools
      bluez-alsa
      nodejs_22
      visidata
      bitwarden
      lazydocker
      pkg-config
      distrobox
      visidata
      geeqie
      glow
      units
      cloudflared
      killall
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;

  };
  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      insecure-registries = [
        "192.168.0.87:5000"
        "docker.home:5000"
      ];
    };
  };
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  services.flatpak.enable = true;

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      monaspace
      cascadia-code
    ];
  };

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    git
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
    wlogout
  ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = [ "hyprland" ];
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  #Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  hardware.graphics = {
    enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}


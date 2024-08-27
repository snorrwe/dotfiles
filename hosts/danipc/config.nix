{ config
, pkgs
, inputs
, host
, username
, options
, ...
}:

{
  imports = [
    ./hardware.nix
    ./sound.nix
    ./video.nix
    ./udev.nix
    ../../commit-message.nix
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

  programs.direnv =
    {
      package = pkgs.direnv;
      silent = false;
      loadInNixShell = true;
      direnvrcExtra = "";
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv;
      };
    };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.snorrwe = {
    isNormalUser = true;
    description = "Dani";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      pavucontrol
      xfce.thunar
      thunderbird
      inputs.wezterm.packages.${pkgs.system}.default
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
      go
      just
      watchexec
      grimblast
      sccache
      lazygit
      ninja
      starship
      pipx
      bat
      btop
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
      zoom-us
      nodejs_22
      bitwarden
      lazydocker
      rustup
      pkg-config
      sccache
      distrobox
      visidata
      geeqie
      flameshot
      glow
      pamixer
      pulseaudio
      units
      cargo-update
      killall
      shotcut
      libreoffice
      arc-theme
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;

  };
  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        insecure-registries = [
          "192.168.0.87:5000"
          "192.168.0.97:5000"
          "docker.home"
        ];
      };
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
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
    };
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
    (
      pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "Monaspace Radon";
        fontSize = "13";
        # background = "${./wallpaper.png}";
        # loginBackground = true;
      }
    )
  ];
  xdg.portal = {
    enable = true;
    config.common.default = [ "gtk" ];
    extraPortals = with pkgs;
      [
        xdg-desktop-portal-gtk
      ];
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.shellInit = ''
    [ -n "$DISPLAY" ] && xhost +si:localuser:$USER >/dev/null || true
  '';

  #Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };


  # my lifebook has trouble waking up after going to sleep so don't do that automatically
  services.logind.lidSwitch = "ignore";
  # certain elements in my life might press the button while I'm working :)
  services.logind.powerKey = "ignore";

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


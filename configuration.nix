# CUSTOM CONFIGURATION Knuspii
# Help is available in the configuration.nix man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Firewall + SSH
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
  services.openssh.enable = false;

  # Timezone / Locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  # Optimize
  services.fstrim.enable = true;
  #services.irqbalance.enable = false;
  nix = {
    settings.auto-optimise-store = true;
    optimise = {
      automatic = true;
      dates = [ "Sun 10:00" ];
    };
    gc = {
      automatic = true;
      dates = "Sun 10:00";
      options = "--delete-older-than 30d";
    };
  };
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    SystemMaxFileSize=50M
    MaxRetentionSec=7day
  '';

  # Swap
  swapDevices = [
    { device = "/swapfile"; size = 8192; } # 8GB
  ];

  # KDE Plasma
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb.layout = "de";

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false; 
    nvidiaSettings = true;
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-code
  ];

  # Global packages
  environment.systemPackages = with pkgs; [
    # Tools
    nano
    git
    curl
    wget
    unzip
    unrar
    dust
    htop
    bottom
    tree
    nmap
    iperf3
    traceroute
    gping
    shellcheck
    fastfetch
    file
    wireguard-tools
    steam-run
    usb-modeswitch
    usbutils
    libnotify
  ];

  # User packages
  users.users.user = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [
      # Dev
      python3
      go
      jq
      gcc
      jdk21

      # GUI
      firefox
      vlc
      gimp
      keepassxc
      libreoffice
      discord
      spotify
      vscode
      prismlauncher
      itch
      conky
    ];
  };

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = { 
          softrealtime = "auto";
          renice = 10;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'GameMode ended'";
        };
      };
    };

  # Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # Version
  system.stateVersion = "25.11";
}

# CUSTOM CONFIGURATION Knuspii
# Help is available in the configuration.nix(5) man page
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
  services.openssh.enable = true;

  # Timezone / Locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  # Optimize
  services.fstrim.enable = true;
  services.irqbalance.enable = false;
  environment.variables.__GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
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
#  services.xserver.videoDrivers = [ "nvidia" ];
#  hardware.nvidia = {
#    modesetting.enable = true;
#    open = false; 
#    nvidiaSettings = true;
#  };

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

  # User
  users.users.user = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [
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
      wireguard-tools
      steam-run

      # Dev
      python3
      go
      jq
      openjdk25
      gcc

      # GUI
      firefox
      vlc
      gimp
      keepassxc
      libreoffice
      discord
      spotify
      vscode
      conky
      libnotify
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

  # Global
  environment.systemPackages = with pkgs; [
    nano
    wget
    curl
  ];

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user" ];

  # Printing
  services.printing.enable = true;

  # Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # Version
  system.stateVersion = "25.11";
}

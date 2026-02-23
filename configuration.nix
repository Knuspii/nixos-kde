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

  # KDE Plasma
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb.layout = "de";

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
      # Terminal / Tools
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
      xclip 
      jq 
      fastfetch
      wireguard-tools

      # Dev
      python3 go openjdk25

      # GUI
      firefox
      vlc
      gimp
      keepassxc
      libreoffice
      discord
      spotify
      vscode
      flameshot
      kitty
      conky
    ];
  };

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

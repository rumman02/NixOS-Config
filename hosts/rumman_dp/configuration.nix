{ username, hostname, homedir, pkgs, alt, stateversion, lib, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    configurationLimit = 20;
    useOSProber = false;
  };

  boot.kernelModules = [ "uinput" "i2c-dev" ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    home = homedir;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "i2c"
      "uinput"
      "input"
      "audio"
    ];
    packages = with pkgs; [
      home-manager
      firefox
      ghostty
      ddcutil
    ];
  };

  services = {
    dbus.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "catppuccin-mocha-mauve";
    };
    udisks2.enable = true;
    timesyncd.enable = true;
  };

  powerManagement.enable = true;
  hardware.i2c.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{power/wakeup}=="disabled", ATTR{power/wakeup}="enabled"
    SUBSYSTEM=="input", KERNEL=="event*", ATTRS{power/wakeup}=="disabled", ATTR{power/wakeup}="enabled"
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    KERNEL=="uinput", GROUP="input", TAG+="uaccess"
    KERNEL=="event*", NAME="input/%k", MODE="0664", GROUP="input"
  '';

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
    ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = false;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  programs.zsh.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  environment.systemPackages = with pkgs; [
    fzf git neovim tree yazi unzip xdg-user-dirs
  ];

  time.timeZone = "Asia/Dhaka";

  system = {
    stateVersion = stateversion;
    autoUpgrade = {
      enable = true;
      dates = "weekly";
    };
  };

  nix = {
    settings = {
      stalled-download-timeout = 300;
      substituters = [ "https://cache.nixos.org" "https://cache.nixos.org/" ];
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
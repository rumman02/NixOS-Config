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
    };
    udisks2.enable = true;
    timesyncd.enable = true;
  };

  powerManagement.enable = true;
  hardware.i2c.enable = true;

  system.stateVersion = stateversion;
}
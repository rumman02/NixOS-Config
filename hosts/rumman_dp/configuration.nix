{ username, hostname, homedir, pkgs, alt, stateversion, lib, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
  };

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    home = homedir;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  system.stateVersion = stateversion;
}
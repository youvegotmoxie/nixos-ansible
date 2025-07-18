{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "snafu-jellyfin-nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "AKDT";

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.qemuGuest.enable = true;
  services.tailscale.enable = true;
  users.users.mike = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    nh
    jellyfin
    jellyfin-ffmpeg
    neovim
    btop
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  networking.firewall.enable = true;
  system.copySystemConfiguration = true;
  system.stateVersion = "25.05";

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };
}

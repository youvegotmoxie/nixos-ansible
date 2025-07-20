{ config, lib, pkgs, ... }:

{
  # Install Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # Setup UWSM configuration for Wayland+Hyprland
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };

  # Hyprland packages
  environment.systemPackages = with pkgs; [
    dunst
    hyprutils
    hyprgraphics
    hyprpaper
    hyprpolkitagent
    pavucontrol
    rbw
    rofi
    rofi-rbw-wayland
    xdg-desktop-portal-hyprland
    waybar
  ];

  # Enable Hypr* utils
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
}

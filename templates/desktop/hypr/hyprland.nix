# TODO: use home-manager to configure hyprland instead of config files
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hypr;
in {
  options.hypr.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
    description = "Enable or disable Hyprland";
  };
  config = lib.mkIf cfg.enable {
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
    xdg.portal.enable = true;

    # Install and configure Flatpak
    services.flatpak.enable = true;
  };
}

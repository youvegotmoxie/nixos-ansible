{
  services.flatpak.uninstallUnmanaged = true;
  services.flatpak.update.auto.enable = true;

  services.flatpak.packages = [
    "com.discordapp.Discord"
    "com.github.tchx84.Flatseal"
    "com.todoist.Todoist"
    "org.squidowl.halloy"
  ];
}

{
  config,
  lib,
  ...
}: let
  cfg = config.backupDrive;
in {
  options.backupDrive.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
    description = "Configure a dedicated backup mount";
  };
  config = lib.mkIf cfg.enable {
    fileSystems."/backups" = {
      device = "/dev/disk/by-uuid/{{ backup_drive_uuid }}";
      fsType = "ext4";
      options = ["noatime" "defaults"];
    };
  };
}

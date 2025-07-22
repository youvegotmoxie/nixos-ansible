{
  # Mount NVMe to /home
  fileSystems."/home" = {
    device  = "/dev/disk/by-uuid/2c267b4d-98fe-4496-a02c-c32b1d19dfd9";
    fsType  = "btrfs";
    options = ["compress=lzo"];
  };

  # Redefine / here so we can turn on compression
  fileSystems."/" = {
    options = ["compress=lzo"];
  };

{% if backup_drive_uuid is defined and enable_backup_drive == True %}
  fileSystems."/backups" = {
    device = "/dev/disk/by-uuid/{{ backup_drive_uuid }}";
    fsType = "ext4";
    options = ["noatime" "defaults"];
  };
{% endif %}
}

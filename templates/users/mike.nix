{
  lib,
  pkgs,
  ...
}: {
  # Create user's main group
  users.groups."{{ username }}" = {};

  # Create user
  users.users."{{ username }}" = {
    isNormalUser = true;
    group = "{{ username }}";
    extraGroups = ["wheel" "users" "qemu-libvirtd" "docker"];
    shell = pkgs.bash;
    home = "/home/{{ username }}";
    createHome = true;
    description = "{{ username }}";
  };

  # Install and configure Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

  # Setup QEMU + KVM
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  # Install Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver = "btrfs";
    rootless = {
      enable = false;
      setSocketVariable = false;
    };
  };
}

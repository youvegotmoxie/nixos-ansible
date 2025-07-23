{pkgs, ...}: let
  restic_passwd_path = "/backups/{{ hostname }}/password.txt";
in {
  # Per-application NixOS configuration
  imports = [
    ./software/atuin.nix
    ./software/bash.nix
    ./software/btop.nix
    ./software/ghostty.nix
    ./software/git.nix
    ./software/starship.nix
    ./software/zoxide.nix
  ];

  # Set home defaults
  home.username = "{{ username }}";
  home.homeDirectory = "/home/{{ username }}";

  # Configure sops
  # TODO: Ansible the manual setup portion of this
  sops = {
    age = {
      keyFile = "/home/{{ username }}/.config/sops/age/keys.txt";
      sshKeyPaths = ["/home/{{ username }}/.ssh/sops_ed25519"];
    };
    # Relative to home.nix config file: /etc/nixos/users/secrets/global.yaml
    defaultSopsFile = ./secrets/global.yaml;
  };

  sops.secrets.restic_password = {path = "${restic_passwd_path}";};

  # Configure home-manager
  programs.home-manager.enable = true;

  # Configure backups
  services.restic.enable = true;
  services.restic.backups = {
    localbackup = {
      exclude = [
        "/home/{{ username }}/.local/share/Steam"
        "/home/{{ username }}/Downloads"
        "/home/{{ username }}/.cache"
        "/home/{{ username }}/.cargo"
        "/home/{{ username }}/.local/share/gnome-boxes"
        "/home/{{ username }}/.local/share/docker"
      ];
      passwordFile = "${restic_passwd_path}";
      pruneOpts = ["--keep-daily 3" "--keep-weekly 2" "--keep-monthly 1"];
      paths = ["/home/{{ username }}"];
      repository = "/backups/{{ hostname }}";
      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = "1h";
      };
      extraBackupArgs = ["--cleanup-cache"];
    };
  };

  # Add public key and rules config
  home.file.".sops.yaml".text = ''
    keys:
      - &{{ username }} age1w2szqkpqpurah7sc88xx0z3j2m068w6gryh6qh2vvpd5s9rd8uusppwsjr
    creation_rules:
      - path_regex: secrets/[^/]+\.(yaml|json|env|ini)$
        key_groups:
          - pgp:
            age:
            - *{{ username }}'';

  # Do this instead of setting up Chezmoi
  home.file.".pre-commit-config.yaml".text = ''
    # See https://pre-commit.com for more information
    # See https://pre-commit.com/hooks.html for more hooks
    repos:
    - repo: https://github.com/pre-commit/pre-commit-hooks
      rev: v5.0.0
      hooks:
      - id: trailing-whitespace
      - id: check-added-large-files
      - id: end-of-file-fixer
    - repo: https://github.com/hhatto/autopep8
      rev: 'v2.3.2'
      hooks:
      - id: autopep8
    - repo: https://github.com/gitleaks/gitleaks.git
      rev: 'v8.28.0'
      hooks:
      - id: gitleaks
    - repo: https://github.com/koalaman/shellcheck-precommit
      rev: v0.10.0
      hooks:
      - id: shellcheck
        exclude: .*jenkins-slave$
    - repo: https://github.com/hadolint/hadolint
      rev: v2.13.1-beta
      hooks:
      - id: hadolint-docker
        args:
        - --ignore=DL3015 # Ignore not using --no-install-recommends with apt
        - --ignore=DL3008 # Ignore not pinning all software package versions (apt-get)
        - --ignore=DL3018 # Ignore not pinning all software package versions (apk)
        - --ignore=SC1091 # Ignore missing shellcheck mock files
    - repo: https://github.com/gruntwork-io/pre-commit
      rev: 'v0.1.30'
      hooks:
      - id: terraform-validate
  '';

  # Set EDITOR to nvim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Setup direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Install user packages
  home.packages = with pkgs; [
    ansible
    ansible-lint
    atuin
    bat
    bfs
    bitwarden
    bitwarden-cli
    brave
    cargo
    delta
    eza
    fd
    gh
    ghostty
    go
    jdk21_headless
    jq
    lazydocker
    lazygit
    nodejs
    pre-commit
    ripgrep
    starship
    tree
    ugrep
    uv
    viddy
    yq
    zoxide
    gnome-boxes
  ];
}

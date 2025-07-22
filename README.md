#### Initial Setup
SOPS needs some pre-configuration

```bash
ssh-keygen -t ed25519 -f ~/.ssh/sops_ed25519
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/sops_ed25519 > ~/.config/sops/age/keys.txt"
nix-shell -p ssh-to-age --run "cat ~/.ssh/sops_ed25519.pub | ssh-to-age"
```

_On macOS you may need to put `keys.txt` in `~/Library/Application\ Support/sops/age`_

Create the SOPS encryption config `~/.sops.yaml`
```yaml
keys:
  - &username $output-from-ssh-to-age-sops_ed25519.pub
creation_rules:
  - path_regex: secrets/[^/]+\.(yaml|json|env|ini)$
    key_groups:
      - pgp:
        age:
        - *username

```

Create the secrets file `files/secrets/global.yaml` with sops
```bash
nix-shell -p sops --run "sops files/secrets/global.yaml"
```

Add the following entry for restic and gh_token
```yaml
restic_password: your-password
gh_token: your-github-token
```

#### Bootstrapping
Get past the chicken egg problem of needing make and nh by using
```bash
nix-shell -p cmake nh --run "make all"
```

Alternatively you can use `nix develop` to create an environment with those tools installed
This will use what's defined in `flake.nix`
```bash
nix develop
```
_If you have [direnv](https://direnv.net/) installed this will already be setup for you once you allow the `.envrc`_

```bash
├── files
│   ├── hypr
│   │   ├── hypridle.conf
│   │   ├── hyprland.conf
│   │   └── hyprlock.conf
│   └── secrets
│       └── global.yaml
├── flake.lock
├── flake.nix
├── inventory
├── main.yaml
├── Makefile
├── README.md
├── tasks
│   └── main.yaml
├── templates
│   ├── desktop
│   │   ├── gnome
│   │   │   └── gnome.nix.j2
│   │   └── hypr
│   │       └── hyprland.nix.j2
│   ├── system
│   │   ├── configuration.nix.j2
│   │   ├── filesystems.nix.j2
│   │   └── flake.nix.j2
│   └── users
│       ├── flatpak.nix.j2
│       ├── home.nix.j2
│       ├── mike.nix.j2
│       └── software
│           ├── atuin.nix.j2
│           ├── bash.nix.j2
│           ├── btop.nix.j2
│           ├── ghostty.nix.j2
│           ├── git.nix.j2
│           ├── starship.nix.j2
│           └── zoxide.nix.j2
└── vars
    ├── global.yaml
    └── snafu-nixos.yaml

13 directories, 28 files
```

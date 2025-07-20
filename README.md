#### Bootstrapping
Get past the chicken egg problem of needing make and nh by using `nix-shell`
```bash
$ nix-shell -p cmake -p nh --run "make all"
```


```bash
├── files
│   └── hypr
│       ├── hypridle.conf
│       ├── hyprland.conf
│       └── hyprlock.conf
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
│           └── starship.nix.j2
└── vars
    ├── global.yaml
    └── snafu-nixos.yaml

12 directories, 24 files
```

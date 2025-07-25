{
  description = "snafu-nixos system flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    comin,
    nixpkgs,
    home-manager,
    nix-flatpak,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    comin_path = "/backups/{{ hostname }}/gh_token";
  in {
    nixosConfigurations = {
      snafu-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Import the main module
          ./configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          comin.nixosModules.comin
          {
          sops = {
            age = {
              keyFile = "/home/{{ username }}/.config/sops/age/keys.txt";
              sshKeyPaths = ["/home/{{ username }}/.ssh/sops_ed25519"];
            };
            # Relative to home.nix config file: /etc/nixos/users/secrets/global.yaml
          };
            sops.defaultSopsFile = ./users/mike/secrets/global.yaml;
            sops.secrets.gh_token = {
              path = "${comin_path}";
            };
            services.comin = {
              enable = true;
              remotes = [{
                name = "nixos-configuration";
                url = "/etc/nixos";
                branches.main.name = "master";
                auth.access_token_path = "${comin_path}";
                poller.period = 30;
              }];
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Move conflicting files out of the way instead of crashing home-manager
            home-manager.backupFileExtension = "hmback";
            home-manager.extraSpecialArgs.flake-inputs = inputs;
            home-manager.users."{{ username }}".home.stateVersion = "25.05";
            # Use Home Manager to manage Flatpaks
            home-manager.users."{{ username }}".imports = [
              # Add sops-nix support for home-manager
              sops-nix.homeManagerModules.sops
              # Flatpak NixOS configuration
              nix-flatpak.homeManagerModules.nix-flatpak
              ./users/{{ username }}/software/flatpak.nix
              # Main home-manager configuration
              ./users/{{ username }}/home.nix
            ];
          }
        ];
        specialArgs = {inherit inputs;};
      };
    };
  };
}

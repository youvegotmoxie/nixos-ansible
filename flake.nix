{
  description = "nixos-ansible tools";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  # Use the default systems flake instead of defining a list of systems
  # [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cmake
            home-manager
            nh
            sops
            ssh-to-age
            alejandra
          ];
        };
      }
    );
}

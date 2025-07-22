{
  description = "nixos-ansible tools";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import inputs.nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cmake
              home-manager
              nh
              nixpkgs-fmt
              sops
              ssh-to-age
            ];
          };
        });
    };
}

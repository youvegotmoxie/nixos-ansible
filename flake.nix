{
  description = "nixos-ansible tools";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nix-pre-commit.url = "github:jmgilman/nix-pre-commit";
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
    nix-pre-commit,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        config = {
          repos = [
            {
              repo = "https://github.com/pre-commit/pre-commit-hooks";
              rev = "v5.0.0";
              hooks = [
                {
                  id = "trailing-whitespace";
                }
                {
                  id = "check-added-large-files";
                }
                {
                  id = "end-of-file-fixer";
                }
              ];
            }
            {
              repo = "https://github.com/gruntwork-io/pre-commit";
              rev = "v0.1.30";
              hooks = [
                {
                  id = "terraform-validate";
                }
              ];
            }
            {
              repo = "https://github.com/hadolint/hadolint";
              rev = "v2.13.1-beta";
              hooks = [
                {
                  id = "hadolint-docker";
                  args = [
                    "--ignore=DL3015" # Ignore not using --no-install-recommends with apt
                    "--ignore=DL3015" # Ignore not using --no-install-recommends with apt
                    "--ignore=DL3008" # Ignore not pinning all software package versions (apt-get)
                    "--ignore=DL3018" # Ignore not pinning all software package versions (apk)
                    "--ignore=SC1091" # Ignore missing shellcheck mock files
                  ];
                }
              ];
            }
            {
              repo = "https://github.com/hhatto/autopep8";
              rev = "v2.3.2";
              hooks = [
                {
                  id = "autopep8";
                }
              ];
            }
            {
              repo = "https://github.com/koalaman/shellcheck-precommit";
              rev = "v0.10.0";
              hooks = [
                {
                  id = "shellcheck";
                  exclude = ".*jenkins-slave$";
                }
              ];
            }
            {
              repo = "https://github.com/gitleaks/gitleaks.git";
              rev = "v8.28.0";
              hooks = [
                {
                  id = "gitleaks";
                }
              ];
            }
          ];
        };
      in {
        devShells.default = pkgs.mkShell {
          shellHook =
            (nix-pre-commit.lib.${system}.mkConfig {
              inherit pkgs config;
            }).shellHook;
          packages = with pkgs; [
            cmake
            home-manager
            nh
            pre-commit
            sops
            ssh-to-age
            alejandra
          ];
        };
      }
    );
}

{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs.buildPackages; [
      sops
      ssh-to-age
      cmake
      nh
      home-manager
    ];
}

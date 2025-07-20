#!/usr/bin/env bash

ansible-playbook -i inventory main.yaml -D
nix-shell -p nixpkgs-fmt --run "nixpkgs-fmt /etc/nixos"
git -C /etc/nixos add .
git -C /etc/nixos commit -m 'updates'
nh os switch /etc/nixos -a

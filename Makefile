
all :
	ansible-playbook -i inventory main.yaml -D
	nix-shell -p nixpkgs-fmt --run "nixpkgs-fmt /etc/nixos"
	git -C /etc/nixos add .
	git -C /etc/nixos commit -m 'updates'
	nh os switch /etc/nixos
	git -C /etc/nixos push origin master

git :
	git -C /etc/nixos add .
	git -C /etc/nixos commit -m 'updates'
	git -C /etc/nixos push origin master

ansible :
	ansible-playbook -i inventory main.yaml -D

switch :
	nh os switch /etc/nixos

dryrun :
	ansible-playbook -i inventory main.yaml -DC

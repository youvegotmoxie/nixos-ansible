
all :
	ansible-playbook -i inventory main.yaml -D
	git -C /home/mike/sync/git/nixos/nixos-configuration add .
	git -C /home/mike/sync/git/nixos/nixos-configuration commit -m '[nixos-ansible] commit from automation'
	git -C /home/mike/sync/git/nixos/nixos-configuration push origin master

dryrun :
	ansible-playbook -i inventory main.yaml -DC

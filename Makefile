
all :
	ansible-playbook -i inventory main.yaml -D
	git -C /etc/nixos add .
	git -C /etc/nixos commit -m '[nixos-ansible] commit from automation'
	nh os switch /etc/nixos
	git -C /etc/nixos push origin master

git :
	git -C /etc/nixos add .
	git -C /etc/nixos commit -m '[nixos-ansible] commit from automation'
	git -C /etc/nixos push origin master

ansible :
	ansible-playbook -i inventory main.yaml -D

switch :
	nh os switch /etc/nixos

dryrun :
	ansible-playbook -i inventory main.yaml -DC

test :
	ansible-playbook -i inventory main.yaml -D
	git -C /etc/nixos add .
	nh os switch -n /etc/nixos

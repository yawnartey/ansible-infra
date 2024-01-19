ansible here we go! 
files
 - inventory: stores information about the host such as IP addresses, domain names etc. file extension is .ini
 - playbook: a yaml file where all instructions of what to do on the host machine are defined (software config, updates, ssl cert installation, etc)
 
ansible is agentless: this implies you do not have to install ansible on host machine, you just have to install it on the master 
 
setting up ansible on aws 
-install ansible on master 
-configure ssh access to ansible host 
-setup ansible host and test connection 

ansible instances 
master -54.145.0.6
host1 - 54.242.233.53
host2 - 100.25.216.228
host3 - 54.234.1.124


setting up ansible 
1. install ansible on master 
-on both master and slave, run the following
sudo apt-get update
-on master node run the following commands
sudo apt install software-properties-common :(to install software properties )
sudo apt-add-repository ppa:ansible/ansible :(to add ansible repo to master)
sudo apt update  :(to update after adding repo on master)
sudo apt install ansible :(to install ansible on master)
-on hosts run the following command 
sudo apt-get install python3 
2. configure ssh access to ansible hosts 
-enable host to be able to accept connection from master (basically enabling keyless access into slave)
generate a keypair on master
 - cd ./ssh 
 - ssh key-gen  
copy and paste content of public key to authorized_keys of hosts
 - cat id_rsa.pub
 - vi authorized_keys  (of hosts)
3. setup ansible host and test connections
add ip address of host in ansible hosts file 
 - vi /etc/ansible /hosts 
create a group and add the hosts 
 - [name_of_host]
 - template below: 
	[production]
	slave1 ansible_ssh_host=54.242.233.53
	slave2 ansible_ssh_host=100.25.216.228
	slave3 ansible_ssh_host=54.234.1.124
test connectivity to hosts 
 - ansible -m ping  all (ping all hosts)
 - ansible -m ping production (ping a group)
4. create a playbook. sample playbook is below 
 - run the playbook using command below 
   ansible-playbook -i hosts playbook.yml --verbose

 
sample playbook to install apache2 server on all hosts 
---
- name: Install apache2 on multiple hosts
  hosts: production
  become: true

  tasks:
    - name: Update package cache (use 'apt' for Ubuntu/Debian)
      apt:
        name: '*'
        state: latest

    - name: Install Apache HTTP server
      package:
        name: apache2
        state: present

    - name: Start the Apache service
      service:
        name: apache2
        state: started

    - name: Enable Apache to start on boot
      service:
        name: apache2
        enabled: yes 
		
run the following command to execute the playbook 
ansible-playbook -i hosts playbook.yml 



ansible playbook explained
ansible playbook explained
name: this is the name of the playbook 
hosts: hosts that the playbook will run on 
become: this tells ansible to use sudo to execute the task
tasks: this is the section where the tasks to be executed are defined 
name: this is the name of the task 
apt: this is the name of the module which is used to install the packages on the target hosts 
name: this specifies the name of the package to be installed 
state: this specifies that the package should be installed if not already present 
service: this is the module used to manage services on the target host
enabled: ensure the httpd service is set to start automatically when the system boots up


some ansible commands 
ansible-playbook -h     :shows options that can be used with this command
ansible-playbook --check playbook.yml  :execute a dry-run of the playbook, without running on hosts
ansible-playbook --syntax-check playbook.yml :check the syntax of the playbook without actually running it
ansible-playbook --list-tasks playbook.yml  :list all tasks that will be executed by the playbook
ansible-playbook --list-host playbook.yml  :list all hosts that will be targeted by the playbook.


ansible lint 
ansible package used to check ansible playbook syntax and ensure the playbook will run without any issues 
sudo apt install ansible lint :to install 
ansible-lint playbook.yml -v :to run checks on the playbook using ansible lint 
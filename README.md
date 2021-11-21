# FOREWORD
Hello Rossum,
This repository contains a solution for [2 given tasks](assignment.txt). Please go through the rest of README, everything is explained below, enjoy.


### REQUIREMENTS
* ansible 2.9+
* ansible collections community.docker and community.general
    - `ansible-galaxy collection install community.docker`
    - `ansible-galaxy collection install community.general`
* docker v1.13.0+ or 17.04.0+
* docker-compose
* terraform binary available in ${PATH}
    - `https://www.terraform.io/downloads.html`
* ports on a localhost available for DB instances
    - `5432, 5551, 5552, 5553`


### PROVISIONING
Provision tasks as follows (both solutions can run simultaneously):
   - `ansible-playbook -i inventory/hosts.yml provision.yml -e 'group=task_1'`
   - `ansible-playbook -i inventory/hosts.yml provision.yml -e 'group=task_2'`

You will find database names, their related ports and all the credentials in STDOUT.

Destroy provisioned solutions running following commands:
   - `ansible-playbook -i inventory/hosts.yml destroy.yml -e 'group=task_1'`
   - `ansible-playbook -i inventory/hosts.yml destroy.yml -e 'group=task_2'`


### EXTENDING PROVISIONED SOLUTION
Simplicity of extending the solution was one of the requirements.
In order to add another DB instance, please edit file inventory/group_vars/task_<id>.yml
Data structure is simplified for the demonstration purposes, therefore you only need to add an item to "task_services" list, the item is a dict containing "service_name" and "port" keys.


### SUGGESTIONS FOR CODE IMPROVEMENTS
Sure, the code can be further improved as always. I am listing a few possible improvements if more time is allocated to spend on this project :)

* check for requirements at the beginning either using a wrapper script or just require Ansible as a prerequisite and validate the rest within Ansible's separate role, perhaps use Ansible automation to fullfill those
* update Terraform code output to represent one value at the time (do not use maps), it will be then easy to create a beautiful output for users
* make use of Ansible Mitogen project to significantly speed the whole provisioning up

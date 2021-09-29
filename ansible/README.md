# Table of Contents
1. [S.T.A.R](#Situation)
2. [File Description](#File-Description)
3. [Useful Information](#Useful-Information)

## S.T.A.R.
### Situation
Being able to deploy one (or multiple) servers with a constant and expectable configuration.

### Task
Adopt Infrastructure as Code (IaC) with Ansible.

### Action
#### Make a copy of the sample files
```
cp roles/base/vars/main.yml.sample roles/base/vars/main.yml
cp hosts.sample hosts
```

#### Edit the files with your configuration
```
nano roles/base/vars/main.yml
nano hosts.yml
```

#### Run the playbook
```
sudo ansible-playbook main.yml0
```

### Result
A completely predicable and ephemeral stack for an Infrastructure.


## File Description

- ansible.cfg

- main.yml

- hosts.sample

- roles - base - tasks

- roles - base - vars

## Useful Information
#### Create password hash command
Needed for roles/base/vars/main.yml.sample
```
mkpasswd --method=sha-512
```

bane readme


# BaNE(Baremetal Node Erector)

Bane builds configurations a la Docker, but directly to bare metal or SSH enabled cloud compute.
It uses Linux / Bash native tooling to reduce the attack surface while still providing Dev and Operations with an easy way to build and manage their Nodes.


## Requirements
(For the management machine)
* A Linux or Mac machine with Python 3.5 or Python 2.7 
* SSH 

(For the nodes)
* A Linux or Mac machine with Python 3.5 or Python 2.6 

If you need to run Ansible from a Windows Box, I believe the WSL is your best bet, but overall it would be better to have a Linux / Mac management system as Ansible absolutely leverages *nix conventions to work well and it does not play nice with Windows.

## Design Considerations:
* Provide a platform to automatically meet some of the ISO 27001 Information Security Management system requirements (Firewall, Monitoring) 

## In Scope
* Ubuntu Server 20.x LTS

## Out of Scope 
* Cloud storage, user management, policies, tags etc. 
* Intrusion Detection and Prevention 
* Web Application Firewall 
* Smart Contracts
* Application security. (eg Node.js, databases, front ends, API’s, etc)
* Legal and Compliance issues relating to Information Technology or Blockchain.

## Removed
* DoD STiG hardening scripts.

## Disclaimer
The author is a consultant with some Chainlink holdings. I'm not responsible for anything you do with this, etc. 

## A Word on Risk Management
This is not a substitute for a risk assessment. The build guide is based on a free, unqualified understanding of the threats and risks operating with blockchain data and networks.
Any enterprise using Bane should benefit from being risk managed on its own merits.

## Requirements on Host:
* Tested on Ansible 2.9.19
* Tested on Ubuntu 20.04
* Tested with Python 3.69

## Installation Instructions:

You will need a live Linux box, with ssh access enabled.
```
git clone and cd into the bane directory 
```

git clone https://github.com/WilsonBillkia/bane.git && cd bane
```
Generate an rsa keypair: (When prompted for a password just press enter twice - and keep the key safe!!!)
```
ssh-keygen -f ./networkkeypair -t rsa -b 4096
```
Build Geth:
```
ansible-playbook vitalik.yml
```
The Vagrantfile also copies the networkkeypair public key to authorized_users on bane, and sets up a private virtual network of 192.168.33.0. You should now be able to ssh into bane with the username vagrant. Ansible commands and the playbook should now also work.

Build the firewall, Install Chainlink, and run Ansible Hardening...

```
ansible-playbook sergey.yml
```

NB Host key checking on your Ansible management server may cause subsequent node spinups to error out until you clear the key from your own ssh client. I use the alias / shellscript killsshkeybane.sh to do this, which basically just replays the help from the sshd output. 

## Operation


## Architecture
The following main components were chosen for this project:

## Ansible (2.9.19)
https://www.ansible.com/ 
Ansible requires only that the node operator have access to the host via SSH. No additional agents or libraries are required. Ansible also provides simple creation and management of test environments and enterprise grade system provisioning and configuration.
NB, while Ansible is clientless there are some modules, such as gather-facts which require Python 2.7 on the host. This should not be an issue with Python 3.

## Ubuntu Server LTS 20.04.
Headless, lightweight and familiar Linux distribution with good support. 



bane readme


# BaNE(Baremetal Node Erector) v0.8


Bane builds blockchain nodes a la Docker, but directly to bare metal or SSH enabled cloud compute.

This version builds  
* a chainlink node with go, node.js, yarn, and postgresql installed  
* an ethereum node with node.js installed

## Requirements
(For the management machine)
* A Linux or Mac machine with Python 3.5 or Python 2.7 
* SSH 
(If you need to run Ansible from a Windows Box, I believe the WSL is your best bet, but overall it would be better to have a Linux / Mac management system as Ansible absolutely leverages *nix conventions to work well and it does not play nice with Windows as a matter of form)

(For the nodes)
* Linux 
* Mac 
* Raspberry Pi (Raspbian or Ubuntu 20 Server)


## Project Goals: 

### Positive Social Impact
* Reduce or entirely remove cloud and hosting costs from projects
* Lower technical and cost barriers for node operation
* Enable potentially eco friendly reuse of obsolete tech
* Enable low power nodes such as Raspberry Pi  


### Secure. 
* Help decentralise networks 
* Compliance with the ISO 27001 Information Security Standard 
* Harden nodes by reducing attack surface; no management agents (only needs python and secure shell)


## In Scope
* Automatic Chainlink Node build
* Automatic Chainlink firewall configuration
* Automatic PostGreSQL Host build (on CL node)
* Automatic Geth Node build
* Key Management

## Out of Scope 
* Cloud storage, user management, policies, tags etc. 
* Intrusion Detection and Prevention 
* Web Application Firewall 
* Smart Contracts
* Application security. (eg Node.js, databases, front ends, API’s, etc)
* Legal and Compliance issues relating to Information Technology or Blockchain.

## Removed
* The (excellent) DoD STiG hardening scripts developed here (https://github.com/openstack/ansible-hardening)
* Vagrant & Virtualbox pipeline used in the Alpha

## Disclaimer
I'm not responsible for anything you do with this. 

## A Word on Risk Management
This is not a substitute for a risk assessment. The build guide is based on a free, unqualified understanding of the threats and risks operating with blockchain data and networks.
Any enterprise using Bane should be risk managed on its own merits.

## Requirements on Host:
* Tested on Ansible 2.9.19
* Tested on Ubuntu 20.04
* Tested with Python 3.69

## (Not required but strongly recommended) 
* Fixed IP / DHCP host reservation on your network.  
Your IP address stops changing on system builds ns restarts, which makes the workflow significantly more practical. (See the manufacturers guidance.)
* Single Board Compute.  


## Installation Instructions:

On your management machine with ansible installed, git clone bane and cd into the directory 

```
git clone https://github.com/WilsonBillkia/bane.git && cd bane
```
(Optional - but recommended, especially for production systems)
Generate an rsa keypair in your working directory: (When prompted for a password just press enter twice and put the key under ISO27001 compliant management) 

This is for the ethereum node
```
ssh-keygen -f vitalik -C "vitaliks key"
```
and for the Chainlink box
```
ssh-keygen -f sergey -C "sergeys key"
```

You will have two keyfiles in your working directory for each command. (WARNING - use appropriate ISMS for your keys)

To copy the keys to the machines:

```
ssh-copy-id -i <KEY FILE> <BOOTACCOUNT>@<IPADDRESS> 
```
Bane needs the optional core community libraries to be installed to ansible using the ansible-galaxy package manager

```
ansible-galaxy collection install community.general 
```

# Build a Chainlink / PostgreSQL Node
System Requirements (Always check with offical xNode documentation)

Run the following command:

```
ansible-playbook sergey.yml -i hosts --ask-pass -kK
```

sergey.yml is an ansible 'playbook' with steps to install geth and node.js.  
The -i switch loads the hosts file we use for asset management. You just add the IP addresses of any nodes to the relevant group within the file (links or ethers)
The -kK switch gathers passwords from operator for ssh and sudo if tasks require it


# Build a GETH Node
System Requirements (Always check with offical Ethereum documentation)

Run the following command:

```
ansible-playbook vitalik.yml -i hosts --ask-pass -kK
```

## Operation


## Architecture
The following main components were chosen for this project:

## Ansible (2.9.19)
https://www.ansible.com/ 
Ansible requires only that the node operator have access to the host via SSH. No additional agents or libraries are required. Ansible also provides simple creation and management of test environments and enterprise grade system provisioning and configuration.
NB, while Ansible is clientless there are some modules, such as gather-facts which require Python 2.7 on the host. This should not be an issue with Python 3.

## Ubuntu Server LTS 20.04.
Headless, lightweight and familiar Linux distribution with good support. 



bane readme


# BaNE(Baremetal Node Erector) v0.8


Bane builds blockchain nodes directly to SSH enabled *nix systems.

## Project Goals: 

### Positive Social Impact
* Reduce or entirely remove cloud and hosting costs from projects
* Enable potentially eco friendly reuse of obsolete tech
* Enable low power / IoT nodes using Raspberry Pi  


### Secure 
* Help decentralise networks 
* Compliance with the ISO 27001 Information Security Standard 
* Harden nodes by reducing attack surface; no management agents (only needs python and secure shell)

# Installation Instructions

## Requirements
(For the management machine)
* Linux or Mac with Python 3.5 
* SSH 
(If you need to run Ansible from a Windows Box, I believe it will work fine in the WSL, but its maybe better to have a Linux / Mac management system as Ansible leverages *nix conventions and it does not play well with Windows as a matter of form. However for simple admin of nodes it should be sufficient)

(For the nodes)
* Linux, Mac, or Raspberry Pi (Raspbian or Ubuntu 20 Server)

V0.8 was tested on Ansible 2.9.19, Ubuntu Server 20.04, Python 3.69


(Optional - but recommended, especially for production systems)
Use an RSA keypair to sign in. An Open SSH port with password auth is not ideal. 

# Build a Chainlink / PostgreSQL Node

System Requirements (Always check with offical documentation)

Bane needs the optional core community libraries to be installed to ansible using the ansible-galaxy package manager:

```
ansible-galaxy collection install community.general 
```

On your management machine with ansible installed:

```
git clone https://github.com/WilsonBillkia/bane.git && cd bane
```

To build a chainlink node with postgreSQL installed run the following command:

```
ansible-playbook sergey.yml -i hosts --ask-pass -kK
```

sergey.yml is an ansible 'playbook' with steps to install geth and node.js.  
The -i switch loads the hosts file we use for asset management - add the IP addresses of any nodes to the relevant group within the file (links or ethers)
The -kK switch gathers passwords from operator for ssh and sudo if tasks require it


# Build a GETH Node
System Requirements (Always check with offical Ethereum documentation)

Run the following command:

```
ansible-playbook vitalik.yml -i hosts --ask-pass -kK
```

## In Scope
* Automatic Chainlink Node build
* Automatic Chainlink firewall configuration
* Automatic PostGreSQL Host build (on CL node)
* Automatic Geth Node build

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
* Key management

## Disclaimer
I'm not responsible for anything you do with this.

## A Word on Risk Management
This is not a substitute for a risk assessment. The build guide is based on a free, unqualified understanding of the threats and risks operating with blockchain data and networks.
Any enterprise using Bane should be risk managed on its own merits.



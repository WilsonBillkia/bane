bane readme


# BaNE(Baremetal Node Erector) v0.8


Bane builds blockchain nodes directly to SSH enabled *nix systems.

## Project Goals: 

### Positive Social Impact
#### Lower barriers to entry of blockchain operation in developing world:
* Reduce or entirely remove cloud and hosting costs from oracle networks
* Simplify reuse of otherwise obsolete tech as nodes
* Accelerate decentralisation of networks 

### Secure 
V0.8 compliments the following ISO 27001 information security control sets;
* Asset management 
* Access control 
* Operations security (bastion hardening)   

# Installation Instructions

## Minimum requirements for the management system  
* Ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* Linux or MacOS (Windows / WSL was tested successully in 2018. It should still work) 
* Python (3.8 or higher)   
* SSH client  


## Minimum requirements for the nodes
* Linux or MacOS (BaNE was tested on Ubuntu Server 20.04 with Python 3.69)  


(Optional - but recommended, especially for production systems)
Use an RSA keypair to sign in. 

## Build a Chainlink / PostgreSQL Node

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

(sergey.yml is an ansible 'playbook' with the steps from the CL github automated to install chainlink.  
The -i switch loads the hosts file we use for asset management; add the IP addresses of any nodes to the relevant group within the file (links or ethers)
The -kK switch gathers passwords from operator for ssh and sudo if tasks require it)


## Build a GETH Node
System Requirements (Always check with offical Ethereum documentation)

Run the following command:

```
ansible-playbook vitalik.yml -i hosts --ask-pass -kK
```
This installs node.js and geth from the Ubuntu repositories.

## In Scope
* Chainlink Node build, Chainlink firewall configuration, PostGreSQL Host build (on CL node), Geth Node build

## Out of Scope
*  Key management, Intrusion Detection and Prevention, Smart Contracts, Application security, Compliance 

## Removed
* The (excellent) DoD STiG hardening scripts developed here (https://github.com/openstack/ansible-hardening)
* Vagrant & Virtualbox pipeline used in the Alpha
* Key management

## Disclaimer
I'm not responsible for anything you do with this.

## A Word on Risk Management
This is not a substitute for a risk assessment. The build guide is based on a free, unqualified understanding of the threats and risks operating with blockchain data and networks.
Any enterprise using Bane should be risk managed on its own merits.



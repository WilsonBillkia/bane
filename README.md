bane readme


# BaNE(Baremetal Node Erector) v0.9


Bane builds blockchain nodes directly to SSH enabled *nix systems.

## Project Goals: 

### Positive Social Impact
#### Lower barriers to entry of blockchain operation in developing world:
* Reduce or entirely remove cloud and hosting costs from oracle networks
* Simplify reuse of otherwise obsolete tech as nodes
* Accelerate decentralisation of networks 

### Secure 
V0.9 compliments the following ISO 27001 information security control sets;
* Asset management 
* Access control 
* Operations security (bastion hardening)   

# Installation Instructions

## Minimum requirements for the management system  
* Ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), including ansible community and posix collections
* Linux (tested on Ubuntu 18.04) or MacOS. (NB Windows / WSL was tested successully in 2018. It should still work) 
* Python (3.8 or higher)   
* SSH client  

## Minimum requirements for the nodes  
* Linux or MacOS (BaNE was tested on Ubuntu Server 20.04 with Python 3.69, not yet tested on osx)  

## Asset Management
Manage your assets by adding their ip addresses to groups in the /etc/ansible/hosts file
Configuration of ansible otherwise is done in /etc/ansible/ansible.cfg  
These files are ansible defaults  

## Build a Chainlink / PostgreSQL Node

System Requirements (Always check with offical documentation)  

Bane needs the optional core community and posix libraries to be installed:  

```
ansible-galaxy collection install community.general  
ansible-galaxy collection install ansible.posix  

```

When you are ready to build some nodes - on your management machine:  

```
git clone https://github.com/WilsonBillkia/bane.git && cd bane
```

use ansible-playbook nodexxx.yml command to  
* Deploy your public key to your nodes  
* Install requirements to all nodes (build-essential, libssl-dev, unzip)  
* Install screen, htop, tcpdump, tree to all nodes (management tools for headless maintenance and monitoring)  
(In these examples lcy is an airport code for the location - use your own naming conventions)  

```
ansible-playbook nodelcy.yml
```

To provision your chainlink nodes:  

```
ansible-playbook linklcy.yml  -kK
```

(linklcy.yml is an ansible playbook with the steps from the CL github automated to install chainlink.  
The -kK switch asks us for a ssh password (-k) and sudo password (-K).  
You will need it first run and then every run unless you generate a key, drop it in files, and reference it in the nodexxx.yml (recommended)  

## Provision GETH Nodes  
For hardware requirements always check with offical Ethereum documentation  

```
ansible-playbook gethlcy.yml 
```
## Provision PostgreSQL Nodes
For hardware requirements always check with offical PostgreSQL documentation

```
ansible-playbook postlcy.yml 
```

## In Scope v0.9
* Key management, Chainlink node, PostGreSQL node, Geth node

## Out of Scope
*  Intrusion Detection and Prevention, Smart Contracts, Application security, Compliance, Firewall 

## Removed
* The (excellent) DoD STiG hardening scripts developed here (https://github.com/openstack/ansible-hardening)
* Firewall Management

## Disclaimer
I'm not responsible for anything you do with this.

## A Word on Risk Management
This is not a substitute for a risk assessment. The build guide is based on a free, unqualified understanding of the threats and risks operating with blockchain data and networks.
Any enterprise using Bane should be risk managed on its own merits.



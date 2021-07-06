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
Complements the following ISO 27001 information security control sets;
* Asset management 
* Access control 
* Operations security (bastion hardening)   

# Installation Instructions

## Minimum requirements for management system  
* Ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), including ansible community and posix collections
* Linux (tested on Ubuntu 18.04) or MacOS. (NB Windows / WSL was tested successully in 2018. It should still work) 
* Python (3.8 or higher)   
* SSH client  
* Node 12.18 tar.gz (always check version against current chainlink github before build) https://nodejs.org/dist/v0.12.18/  
* Go 1.15 tar.gz (works with 1.16 though) https://golang.org/dl/  
* The above two files get copied to your nodes at build from the management server. Save them in /files then refer to them in roles/sergey/tasks/main.yml  

## Minimum requirements for the nodes  
* Linux or MacOS (BaNE was tested on Ubuntu Server 20.04 with Python 3.69, not yet tested on osx)  


## Asset Management
Manage your assets by adding their ip addresses to groups in the /etc/ansible/hosts file  
Configuration of ansible otherwise is done in /etc/ansible/ansible.cfg  
Both files are ansible defaults.  

## Provision Chainlink Nodes  

Hardware requirements (Always check with offical documentation)  

Bane needs the optional core community and posix libraries to be installed on your management machine:  

```
ansible-galaxy collection install community.general  
ansible-galaxy collection install ansible.posix  
```

When you are ready to build some nodes:  

```
git clone https://github.com/WilsonBillkia/bane.git && cd bane
```

use ansible-playbook node.yml command to  
* Deploy your public key to your nodes  
* Install requirements to all nodes (build-essential, libssl-dev, unzip)  
* Install screen, htop, tcpdump, tree to all nodes (management tools for headless maintenance and monitoring)  

```
ansible-playbook node.yml
```

To provision your chainlink nodes:  

```
ansible-playbook link.yml  -kK
```

(link.yml is an ansible playbook with the steps from the CL github automated to install chainlink.  
The -kK switch lets us pass a ssh password (-k) and sudo password (-K).  
You will need it first run and then every run unless you generate a key, drop it in files, and reference it in the roles/node/main.yml playbook (recommended)  

## Provision GETH nodes  
For hardware requirements always check with offical Ethereum documentation  

```
ansible-playbook geth.yml 
```
## Provision PostgreSQL nodes
For hardware requirements always check with offical PostgreSQL documentation

```
ansible-playbook post.yml 
```

## In Scope v0.9
* Key management, Chainlink node, PostGreSQL node, Geth node
* Idempotence

## Out of Scope
*  Configuration management, Intrusion Detection and Prevention, Smart Contracts, Application security, Compliance, Firewall 

## Removed
* The (excellent) DoD STiG hardening scripts developed here (https://github.com/openstack/ansible-hardening)

## Disclaimer
I'm not responsible for anything that you do with this.

## A Word on Risk Management
This is not a substitute for a risk assessment. The build guide is based on a free, unqualified understanding of the threats and risks operating with blockchain data and networks.
Any person or organisation using Bane should manage risk accordingly.

## Contact us
wilsonbillkia@gmail.com




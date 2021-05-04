bane readme


# BaNE(Baremetal Node Erector)
*THIS VERSION IS A TEST AND WILL NOT DEPLOY A CHAINLINK NODE. IT SHOULD BUILD A GETH NODE*
*

Bane builds blockchain nodes a la Docker, but directly to bare metal or SSH enabled cloud compute.
Ansible uses Linux / Bash native tooling to reduce the attack surface while still providing Dev and Operations with an easy way to build and manage their Nodes.

This version builds a Chainlink node and a local geth node. Both have node.js installed by default.

## Requirements
(For the management machine)
* A Linux or Mac machine with Python 3.5 or Python 2.7 
* SSH 

(For the nodes)
* A Linux or Mac machine with Python 3.5 or Python 2.6 

If you need to run Ansible from a Windows Box, I believe the WSL is your best bet, but overall it would be better to have a Linux / Mac management system as Ansible absolutely leverages *nix conventions to work well and it does not play nice with Windows as a matter of form sadly.

## Project Goals: 
  
### Secure. 
* Decentralise nodes at scale outside the main cloud providers
* Be compliant with ISO 27001 Information Security control sets 
* An alternative to securing containers in production

### Positive Social Impact
* Reduce or remove cloud costs
* Lower the barrier for entry for node operation
* Enable potentially eco friendly reuse of obsolete tech
* Enable low power nodes such as Raspberry Pi

## In Scope
* Ubuntu Server 20.x LTS
* Raspberry Pi

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
* DHCP host reservation. 
This can be found on all but the most basic of routers / Wireless Access Points / some NAS's. With this enabled your IP address stops changing on system restarts, which makes the workflow significantly more practical. (See the manufacturers guidance.)
* Single Board Compute 
Old pc's are great, but the open architecture means automation of OS install is quite technical in order to accomodate enterprise class network boot and install of the pc base. A sufficiently specified Raspberry Pi, conversely, has a tightly defined architecture which means you can securely build a system using a temporary login saved to the install media. Bane can then remove this login and replace it with the SSH keys of your choice. 

## Installation Instructions:

git clone and cd into the bane directory 

```
git clone https://github.com/WilsonBillkia/bane.git && cd bane
```

Generate an rsa keypair in your working directory: (When prompted for a password just press enter twice) 

This is for the ethereum node
```
ssh-keygen -f vitalik -C "ethereum node key"
```
and for the xnode box
```
ssh-keygen -f xuser -C "xnode node key"
```

You will have two keyfiles in your working directory for each command. (WARNING - use appropriate ISMS for your keys)

To copy the keys to the machines:

```
ssh-copy-id -i <KEY FILE> <BOOTACCOUNT>@<IPADDRESS> 
```

# GETH Node
System Requirements (Always check with offical Ethereum documentation)
run the following command:

```
ansible-playbook vitalik.yml -i <IPADDRESS OF BOX> -l ethers --ask-pass 
```

# Chainlink Node
System Requirements (Always check with offical xNode documentation)

```
ansible-playbook sergey.yml -i <IPADDRESS OF BOX> -l xnode --ask-pass 
```

# Chainlink Database
System Requirements (Always check with offical xNode documentation)

```
ansible-playbook xnode.yml -i <IPADDRESS OF BOX> -l db --ask-pass 
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



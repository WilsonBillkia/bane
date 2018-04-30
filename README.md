# bane

## Automated Build for a Hardened Chainlink Node
A basic Ansible playbook for rapid deployment of a US DOD security hardened Chainlink node. 

Version One...
* Builds a Virtualbox Chainlink VM.
* Installs a bespoke iptables firewall for Chainlink traffic 
* Applies the Openstack Ansible Hardening role for US DoD STIG  

This repository builds a virtual machine (using the Vagrantfile) but the seperate Ansible playbook can work on any linux host with a suitable user and keypair. Eg if you set up a raspberry pi or Amazon EC2 instance with SSH enabled it should be trivial to run the playbook against it.

NB most of the heavy lifting here is someone elses code: the excellent Openstack Ansible Hardening project. 

https://github.com/openstack/ansible-hardening 

All I've done is select a basic security model and automate the latest Chainlink Alpha build guide.

## About This Build Guide
* This build guide proposes a high level model for securing multiple Chainlink nodes.
* Leverages United States Department of Defense Security Technical Implementation Guides (DoD STIG) as the security baseline
* Complements ISO 27001 standards for Information Security Management (ISM) 
* In no way endorses Christopher Nolan 

## Design Considerations:
* Work within current ISO 27001 standards for Info Sec Manamenet.
* Consistency with Phase One of the ChainLink project (high reliance on per host security, and no recourse to enclaving)
* Lightweight - enables provisioning of Internet of Things / bare metal devices, providing greater opportunity for innovative Oracles
* Automate implementation of US DoD standards.
* Automate review of US DoD standards.
* Avoid containers and so remove them as an attack vector entirely.
* Agentless Management to further reduce attack surface

## In Scope
* Ubuntu Server 16.04 LTS operating system hardening on virtual machines

## Out of Scope 
* Cloud storage, user management, policies, tags etc. 
* Intrusion Detection and Prevention for the Chainlink API
* Web Application Firewall configuration for the Chainlink API
* Smart Contract audit
* Application security. (eg Node.js, databases, front ends, API’s, etc)
* Legal and Compliance issues relating to Information Technology or Blockchain.

## Disclaimer
The author is a security consultant with some Chainlink holdings. I'm not responsible for anything you do with this, etc. 

## A Word on Risk Management
This is not a risk assessment. The build guide is based on a limited understanding of the threats and risks specific to the processing of blockchain data and the basic business model of Chain Link or other blockchains.
Any enterprise using these technologies should benefit from being risk managed on its own merits.

## Requirements on Host:
Tested on the following:
* ansible 2.5.0
* Vagrant 2.0.1

## Requirements on Guest
The Vagrantfile is currently locked to install the 20180316.0.0 (Mid March '18) release of Ubuntu Xenial from https://app.vagrantup.com/boxes/search. To change this to the absolute latest release just remove / comment the vm.box_version line from the Vagrantfile. 

## Installation Instructions:
First, git clone and cd into the bane directory 
```
git clone https://github.com/WilsonBillkia/bane.git && cd bane
```
Generate the rsa keypair:
```
ssh-keygen -f ~/networkkeypair -t rsa -b 4096
```

Install the Openstack Ansible Hardening role so it can be pushed to our nodes.
```
ansible-galaxy install --roles-path ./roles git+https://github.com/openstack/ansible-hardening
```
(This copies the Openstack Ansible Hardening role to a new dir under the current working directory on your VM host. NB by default ansible roles are installed by galaxy in /etc/ansible/roles. We're installing local copies to tweak security settings.) 

Read the Vagrantfile and create a virtual Ubuntu Xenial server called bane... 

```
vagrant up  
```
The Vagrantfile also copies the networkkeypair public key to authorized_users on bane, and sets up a private virtual network of 192.168.33.0. You should now be able to ssh into bane with the username vagrant. Ansible commands and the playbook should now also work.

Build the firewall, Install Chainlink, and run Ansible Hardening...

```
ansible-playbook fire_rises.yml
```

![See some output here](bane.jpg?raw=true "Building a Chainlink")

## Operation

To check the status of the hardening you can run the ansible playbook in --check mode and you can apply four different levels of verbosity using the (-v ... -vvvv) flags.

![See some output here](stig_guide.PNG?raw=true "Hardening Output")

Ansible is declarative. If the step shows as OK, that means it's in place. If it says changed, then it has just been altered to the desired setting. 'Skipping' is described below.

The Openstack Ansible Hardening scripts will skip some steps, usually for hardening measures which require operator involvement or a better understanding of the operations and environment. These can now be seperated out from the security measures that pass to be secured individually.

To adjust the settings on your hardened guests make the necessary changes to the Ansible Hardening roles main playbook under .ansible/roles/... under your project directory.



## Architecture
The following main components were chosen for this project:

## Ansible (2.5.0)
https://www.ansible.com/ 
Ansible requires only that the node operator have access to the host via SSH. No additional agents or libraries are required. Ansible also provides simple creation and management of test environments and enterprise grade system provisioning and configuration.
NB, while Ansible is clientless there are some modules within it which require libraries to be available on the host. This is the case with the Ansible Hardening scripts and Python 2.7 

## Vagrant 
https://www.vagrantup.com/ 
Vagrant can use VMWare and so is largely cloud agnostic. It also supports VirtualBox well, and so provides a simple and free toolset for a test lab.

## US DOD / STIG
https://iase.disa.mil/stigs/Pages/index.aspx
The body of knowledge is trusted, well maintained, and maps into information security management and a number of legal and regulatory requirements in a way which is consistent and manageable. 
NB Other standards exist (US Centre for Internet Security or CIS builds.) US DOD STIG was chosen because it is more granular (CIS has two basic standards of Level One and Level Two whereas STIG uses a matrix. The matrix approach of DOD provides us with the opportunity to expose fine grained reporting of security controls onto the blockchain itself.)
Finally DOD STIG was chosen because an automated implementation of it has been made available by the Ansible Hardening project…

## Ansible Hardening
https://github.com/openstack/ansible-hardening 
This Red Hat funded, open source project supports a wide variety of Linux operating systems.
NB. Full, commercial support is available for Red Hat only. However in testing on Ubuntu the majority of fixes work out of the box, and issues can be easily followed from the Ansible Hardening output when running in dry run (ansible --check) mode. 


## Ubuntu Server LTS 16.04.
Headless, lightweight and familiar Linux distribution with good support. Chosen for it’s ubiquity and the authors own familiarity with it. System builders with a preference for Red Hat should probably use it instead as the STIG Ansible Hardening has Red Hat as its main focus for commercial support. 

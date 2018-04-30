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

## Requirements on Host:
Tested on the following:
* ansible 2.5.0
* Vagrant 2.0.1

## Requirements on Guest
The Vagrantfile is currently locked to install the 20180316.0.0 (Mid March '18) release of Ubuntu Xenial from https://app.vagrantup.com/boxes/search. To change this to the absolute latest release just remove / comment the vm.box_version line from the Vagrantfile. 

## Installation Instructions:
First generate the keypair that ansible will use for passwordless ssh access:
```
ssh-keygen -f ~/networkkeypair -t rsa -b 4096
```

The Openstack Ansible Hardening Role needs to be installed so it can be pushed to our nodes on request. To do this run...
```
ansible-galaxy install --roles-path ./roles git+https://github.com/openstack/ansible-hardening
```
...to copy the Openstack Ansible Hardening role to a new dir under the current working directory on your VM host. NB the default ansible location for roles installed by galaxy is /etc/ansible/roles and these copies are read only. We want local copies which we can use to tweak security settings. Ansible typically looks for a local copy of most config files in the first instance, then defaults back to the read only ones if none are available. 

Then run...
```
vagrant up  
```
This reads the Vagrantfile and provides a virtual Ubuntu Xenial server called bane. 
The Vagrantfile also copies your public key to authorized_users on the server, sets up a private network of 192.168.33.0 (in addition to the default management network which Vagrant provides), and gives the virtual guest an interface onto it.  

You should now be able to ssh into the machine using its ip address and the username vagrant. Ansible commands and the playbook should now also work on the guest.  

```
ansible-playbook chainlink_install.yml
```
This installs our requirements on Bane (Python 2.x, Go, etc, and builds Chainlink from source using the Chainlink github)

![See some output here](bane.jpg?raw=true "Building a Chainlink")
```
ansible-playbook fire_rises.yml
```
This applies the Openstack Ansible Hardening Role onto Bane.  
You should now have a hardened build to play around with. 

Not all the hardening steps of the DOD STIG have been applied, but a great many have by default. So we now have a (semi) hardened box that we can just as easily promote into production as we can tear it up and start again (my boxes build in about five minutes with an old centrino desktop doing the virtualisation.)

To check the status of the hardening you can run the ansible playbook in --check mode and you can apply four different levels of verbosity using the (-v ... -vvvv) flags.

Ansible is declarative. If the step shows as OK, that means it's in place. If it says changed, then it has just been altered to the desired setting. 'Skipping' is described below.

![See some output here](stig_guide.PNG?raw=true "Hardening Output")

## Operation

The Openstack Ansible Hardening scripts will skip some steps, usually for hardening measures which require operator involvement or a better understanding of the operations and environment. 

For example the iptables firewall is disabled by default because the ports required by the system need to be explained to it. Also, based on the environment, it could be that you want to manage your firewall elsewhere, such as within AWS, or whatever your host environment is, in which case you'd just manage that by dovetailing it and commenting on it for future ansible checks required by IT Audit, regulators, etc. In this case I've set up an iptables firewall that allows for basic operation.

Another example is there is no off box logging enabled. Again, this needs some configuration based on what your syslogging infra is - if you have one! But if you're just a 'mom and pop' and you don't have the resource to setup proper, off box logging (you really should though) then you can just mark these skipped steps, and focus on what little security you'll get from having the logs stored on the node.

To adjust the settings on your hardened guests make the necessary changes to the Ansible Hardening roles main playbook under .ansible/roles/... under your project directory.

The output can be seen clearly each time you run the script. Once you have your hardened build you can run ansible-playbook with the --check option to gather the output for your ongoing security audits.


## About This Build Guide
* This build guide proposes a high level model for securing multiple Chain Link nodes.
* Leverages United States Department of Defense Security Technical Implementation Guides (DoD STIG) as the security baseline
* Complements ISO 27001 standards for Information Security Management (ISM) 
* In no way endorses Christopher Nolan 

## Assumptions:
* We want to enable strategies for security automation which can apply to both bare metal and virtual (cloud) environments.
* We want to work within current ISO 27001 standards for ISM.

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


## Architecture
The goals of the architecture were:
* Consistency with Phase One of the ChainLink project (high reliance on per host security, and no enclaving)
* Lightweight - enables provisioning of Internet of Things / bare metal devices, providing greater opportunity for innovative Oracles
* Automating implementation and review of US DoD standards available in the Ubuntu Linux operating system.
* Leverage pre existing, well trusted, Linux system level security hardening models and standards.
* Avoid containers and so remove them as an attack vector entirely.
* Agentless Management to reduce attack surface
* Integrates well with Elastic Compute style cloud solutions. 
* Supports Go version of ChainLink, (current as at April‘18)

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

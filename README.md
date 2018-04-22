# bane

## Automated Build and Hardening Guide For a Chainlink Node
A set of ansible playbooks for rapid deployment of Chainlink and Ethereum nodes. 
Version One builds a Chainlink VM and an Ethereum VM on a virtual network 192.168.33.* , and can apply the Openstack Ansible Hardening role for US DoD STIG on them both (just change the ip address in the stig_guide.yml script to the host you want to harden.) 

The Ansible playbooks use Vagrant and VirtualBox VMs for the provisioning but they should work on any linux host with whatever user and  keypair you want to use to manage things on it. (I set this up mainly to do some stuff with raspberry pi's)

NB most of the heavy lifting here is someone elses code: the excellent Openstack Ansible Hardening project. All I've done is automate the build of the lab and select technologies and a security model.

## Requirements on Host:
Tested on the following:
* ansible 2.5.0
* Vagrant 2.0.1
* Openstack Ansible Hardening role installed in ansible roles on Host VM

## Installation Instructions:
This version contains references throughout to the keypair I used for ansible (networkkeypair)
If you don't have an existing keypair then first generate your own keypair for ansible to use:
```
ssh-keygen -t rsa -b 4096
```
and update the references to networkkeypair and networkkeypair.pub in this repository with your own keys and their locations. This enables ansible (and you) to ssh in to your nodes without having to protect a password.

The Openstack Ansible Hardening Role needs to be installed so it can be pushed to our nodes on request. To do this run...
```
ansible-galaxy install --roles-path ./roles git+https://github.com/openstack/ansible-hardening
```
...to copy the Openstack Ansible Hardening role to a new dir under the current working directory on your VM host. NB the default ansible location for roles installed by galaxy is /etc/ansible/roles and these copies are read only. We want local copies which we can use to tweak security settings. Ansible typically looks for a local copy of most config files in the first instance, then defaults back to the read only ones if none are available. 

Then run...
```
vagrant up all 
```
This reads the Vagrantfile and provides two virtual Ubuntu Xenial servers - bane and cia. 
The Vagrantfile also copies your public key to authorized_users on each server, sets up a private network of 192.168.33.0 (in addition to the default management network which Vagrant provides), and gives each guest an interface onto it.  

You should now be able to ssh into either machine using their ip address and username vagrant. Ansible commands and playbooks should now also work on the guests.  

NB you can also just run vagrant up bane or vagrant up cia to provision and boot individual guests.

```
ansible-playbook chainlink_install.yml
```
This installs our requirements on Bane (Python 2.x, Go, etc, and builds Chainlink from source using the Chainlink github)

![See some output here](bane.jpg?raw=true "Building a Chainlink")
```
ansible-playbook stig_guide.yml
```
This applies the Openstack Ansible Hardening Role onto Bane.  
You should now have a hardened build to play around with. 

To also turn CIA into an Ethereum node just type: 
```
ansible-playbook geth_them_onboard.yml
```
That's it, you now have a virtual lab built with 1x Chainlink node (hardened) and 1x Ethereum node (unhardened) To apply the different playbooks to the different hosts just swap the ip address under hosts at the start of each script.

Not all the hardening steps of the DOD STIG have been applied, but a great many have by default. So we now have a (semi) hardened box that we can just as easily promote into production as we can tear it up and start again (my boxes build in about five minutes with an old centrino desktop doing the virtualisation.)

To check the status of the hardening you can run the ansible playbook in --check mode and you can apply four different levels of verbosity using the (-v ... -vvvv) flags.

Ansible is declarative. If the step shows as OK, that means it's in place. If it says changed, then it has just been altered to the desired setting. 'Skipping' is described below.

![See some output here](stig_guide.PNG?raw=true "Hardening Output")

## Operation

The Openstack Ansible Hardening scripts will skip some steps, usually for hardening measures which require operator involvement or a better understanding of the operations and environment. 

For example the iptables firewall is disabled by default because the ports required by the system need to be explained to it. Also, based on the environment, it could be that you want to manage your firewall elsewhere, such as within AWS, or whatever your host environment is, in which case you'd just manage that by dovetailing it and commenting on it for future ansible checks required by IT Audit, regulators, etc. 

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

# bane

## Build Guide For a Chainlink Node v 0.9
A vagrant / ansible lab for building idempotent Chainlink nodes. Version One just builds a couple of VM’s with Chainlink installed, and applies the Openstack ansible hardening role for US DoD STIG. 
(This is an early version, not quite finished, but should run and build two chainlink boxes - it’s two because my early build needs to be changed and have one running geth, or just shelved, but for now two is better than one right?)

## Requirements on Host:
* ansible 2.5.0
* Vagrant 2.0.1
* Openstack Ansible Hardening role installed in ansible roles on Host VM

## Installation Instructions:
```
ansible-galaxy install git+https://github.com/openstack/ansible-hardening
```
```
vagrant init
```
```
vagrant up all 
```
(this has brought up two vm’s - bane and cia - check them by running vagrant status)
```
ansible-playbook chainlink_install.yml
```
```
ansible-playbook masterplan.yml
```
You should now have two hardened builds to play around with.

## About This Build Guide
* This build guide proposes a high security level architecture for securing multiple Chain Link nodes.
* Leverages United States Department of Defense Security Technical Implementation Guides (DoD STIG) as the security baseline
* Complements ISO 27001 standards for Information Security Management (ISM) 

## Assumptions:
* We want to enable strategies for security automation which can apply to both bare metal and virtual (cloud) environments.
* We want to work within current ISO 27001 standards for ISM.

## In Scope
* Ubuntu Server 16.04 LTS operating system hardening

## Out of Scope 
* Cloud storage, user management, policies, tags etc. 
* Intrusion Detection and Prevention for the Chainlink API
* Web Application Firewall configuration for the Chainlink API
* Smart Contract audit
* Application security. (eg Node.js, databases, front ends, API’s, etc)
* Legal and Compliance issues relating to Information Technology or Blockchain.

## Disclaimer
The author is a security consultant with some Chainlink holdings. 


## A Word on Risk Assessment
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

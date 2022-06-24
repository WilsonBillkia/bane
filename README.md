

  

# BaNE(Baremetal Node Erector) v1.1 

## BaNE?
Baremetal Node Erector is a toolset for managing Chainlink networks on Ubuntu server. 

It's the public / pro bono version of the tools I use to run my bane.sh oracles across a higgledy piggledy network of rusty old compute. 

This version is designed to help students and the generally cash strapped deploy their own chainlink oracles across old compute / away from cloud, while serving as a baseline build for security enhancements etc. It might be useful if you want to build a lab.

For details on the bane.sh oracle network just go to https://www.bane.sh


## What does this do?
The default install here creates a class C, NAT'ed network consisting of Chainlink nodes, a postgreSQL backend, and an Ethereum node. Just point the code at the right kit. It will build chainlink from source, set up a geth client and install postgres on the systems provided in your inventory file.  

## Security
Bane supports the deployment of chainlink networks on bare metal. This allows networks to extend outside of cloud providers, with the decentralisation and key management benefits that brings. 

The project was started principally as an alternative to managing nodes using containers.

The toolset is designed to comply with  ISO 27001 [standards](https://www.iso.org/standard/54534.html) for information security management.  

If you just want to run a test network, this repo does not require any knowledge of ansible to set up, though some [orientation](https://docs.ansible.com/) will help.  

Otherwise, Ansible skills are essential if running production systems.  Ansible was chosen as a means of deploying native Linux security for blockchain security. Polygon uses it for their node deployments also! Substantial security controls can be leveraged through adherence to Ansible's best practices.  

NB! SSH IP connectivity on your nodes is assumed to be restricted to your management host ONLY throughout, or at the very least as taking place on a trusted network. An Internet facing SSH port is possible but definitely not advised.   

## Minimum Requirements  
* 3 x Ubuntu Server 20.04 hosts (4 for basic CL redundancy)
* 1 x Management host with ansible (Linux, Mac, or Windows)

NB Any Debian based host should work. 

## Instructions  


### Step 1 - Prerequisites and Asset Management  

Install ansible on your management host, being sure to include the ansible community and posix collections.
```
sudo apt update
sudo apt install ansible
ansible-galaxy collection install community.general ansible.posix
```

Add your ubuntu server IP addresses to the /etc/ansible/hosts file on your management machine (you should need sudo for this). You can refer to the [hosts_example](../master/hosts_example) file to see the groups used for asset management (node, link, post, geth.) These can be any Ubuntu hosts with IP connectivity and SSH.


Bane builds it's chainlink nodes from source, so you will need the correct versions of NodeJS and Go saved on your management machine. As of Chainlink v1.2.1 / April 2022 these are  
* [Node 16.14](https://nodejs.org/dist/latest-v16.x/node-v16.14.2-linux-x64.tar.gz)
* [Go 1.18](https://golang.org/dl/)

Save your node and go installers to the files directory as node.tar.gz and go.tar.gz respectively. They will then get copied to your nodes if and when required.

BaNE manages environments using the ansible.builtin.lineinfile module to apply configuration to the /etc/environment file.  

To apply your environment variables on the hosts, check out the settings in roles/sergey/tasks/main.yml for PATH and GOBIN etc for basic usage of the module.  

### Step 2 - Setup the Network   
 (After this the order of the remaining steps doesn't matter.)  

To build the network: 
```
ansible-playbook node.yml
```
NB If you don't have public keys on your hosts, run the above command with the -kK switch (ansible-playbook -kK node.yml).  This prompts for an ssh (-k) and sudo (-K) password and SCP's your key across to enable passwordless authentication from thereon.  

The ansible-playbook node command also installs the build requirements from APT (build-essential, libssl-dev, unzip)  

Finally, it uses APT to install screen, htop, tcpdump, and tree. You can alter this list to better reflect your preferred systems management tools by providing the names of the packages you need in the YAML list under roles/sergey/tasks/main.yml  


### Step 3 -Build the Chainlink nodes
 
```
ansible-playbook link.yml
```

link.yml downloads Go and NodeJS, installs them, installs Yarn via NPM, clones the chainlink repo, then compiles it from source on each chainlink node.  
 
### Step 4 - Build PostgreSQL nodes

```
ansible-playbook post.yml 
```

This installs a POSTGRESQL 12 database using APT.  Refer to the official [chainlink](https://docs.chain.link/docs/connecting-to-a-remote-database/) and [Postgresql]((https://www.postgresql.org/docs/12/server-start.html)) guidance for PostgresQL 12 Database setup.

### Step 5 - Build GETH node(s)  

```
ansible-playbook geth.yml 
```
This installs Go Ethereum from the Ubuntu APT. This can then be configured to run as required (eg mainnet / testnet , lightmode, etc) 


## Social Impact
The project hopefully has the potential to realise some positive social impact: 
* Can potentially help with the re-use of IT assets in the developing world into physically secure, community led blockchain projects / agricultural / IoT applications, etc.
* Provides testing & training tools for building cheap blockchain development labs

## Risk Management & Disclaimer
These tools are based on a free, unqualified analyis of the threats and risks operating with blockchain data and networks. Any person or organisation using Bane should manage their risk appropriately.
Also, I'm not responsible for anything you do with this! Please be careful.

## Contact
wilsonbillkia@gmail.com

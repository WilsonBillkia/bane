

  

# BaNE(Baremetal Network Extender) v1.2 

## BaNE?
Baremental Network Extender (previously Baremetal Node Erector) is a toolset for managing Chainlink networks on debian based hosts running apt. You just need SSH enabled. 

It's the public / pro bono version of the tools I use to run oracles on bare metal. 

It gives freedom to deploy away from cloud, while also playing very well with all of the cloud providers, to enable truly hybrid infrastructure. It also serves as a suitable baseline for security management under ISO27001. It might be useful if you want to build a lab. It will be especially useful if you want to remove containers from the build and management of chainlink networks, or if you want to add bare metal,  old hardware or virtual machines to a chainlink network.


## What does this do?
Bane will build chainlink nodes on any suitable linux hosts you specify. The link hosts are chainlink nodes. The post hosts are the backend PosgreSQL databases.

## Security
Bane supports the deployment of chainlink networks on bare metal. This allows networks to extend outside of cloud providers, with the decentralisation and key management benefits that brings. 

The project was started principally as an alternative to managing nodes using containers.

The toolset is designed to comply with  ISO 27001 [standards](https://www.iso.org/standard/54534.html) for information security management.  

If you just want to run a test network, this repo does not require any knowledge of ansible to set up, though some [orientation](https://docs.ansible.com/) will help.  

Otherwise, Ansible skills are essential if running production systems.  Ansible was chosen as a means of deploying native Linux security for blockchain security. Polygon and Polkadot use it for their node management. Substantial security controls can be leveraged through adherence to Ansible's best practices, notably by reducing the attack surface by using ssh.  

NB! SSH IP connectivity on your nodes is assumed to be restricted to your management host ONLY throughout, or at the very least as taking place on a trusted network. An Internet facing SSH port is possible but definitely not advised.   

## Minimum Requirements  
* Chainlink nodes need 2x CPU cores and 4GB RAM 
* Databases need 4x CPU cores, 100GB of storage, and 16GB RAM

NB Any Debian based host should work. Bane was tested on Ubuntu Server 22 

## Instructions  


### Step 1 - Prerequisites and Asset Management  

Install ansible on your management host, being sure to include the ansible community and posix collections.
```
sudo apt update
sudo apt install ansible
ansible-galaxy collection install community.general ansible.posix
```

Add your IP addresses to the hosts file. You can use the example hosts_example.yml file with the ansible-playbook -i switch. Look after your hosts file in ansible. Back it up and keep it secure. 


You will need the correct versions of NodeJS and Go.


* [NodeJS 16](https://nodejs.org/en/blog/release/v16.16.0)
* [Go 1.21](https://golang.org/dl/)

Save your node and go installers to the files directory as node.tar.gz and go.tar.gz


### Step 2 - Setup the Network   
 (After this the order of the remaining steps doesn't matter.)  

To build the network: 
```
ansible-playbook node.yml
```
NB If you don't have public keys on your hosts, run the above command with the -kK switch (ansible-playbook -kK node.yml).  This prompts for an ssh (-k) and sudo (-K) password and SCP's your key across to enable passwordless authentication from thereon.  

The ansible-playbook node command also installs the build requirements from apt (build-essential, libssl-dev, unzip)  

Finally, it uses apt to install screen, htop, tcpdump, and tree. You can alter this list to better reflect your preferred systems management tools by providing the names of the packages.  


### Step 3 -Build the Chainlink nodes
 
```
ansible-playbook link.yml
```

link.yml installs Go and NodeJS and clones the chainlink repo.  
 
### Step 4 - Build PostgreSQL nodes

```
ansible-playbook post.yml 
```

This installs a POSTGRESQL 12 database to the hosts of your choice using apt.  Refer to the official [chainlink](https://docs.chain.link/docs/connecting-to-a-remote-database/) and [Postgresql]((https://www.postgresql.org/docs/12/server-start.html)) guidance for PostgresQL 12 Database setup.


## Social Impact
The project hopefully has the potential to realise some positive social impact: 
* Can potentially help with the re-use of IT assets in the developing world into physically secure, community led blockchain projects / agricultural / IoT applications, etc.
* Provides testing & training tools for building cheap blockchain development labs

## Risk Management & Disclaimer
These tools are based on a free, unqualified analyis of the threats and risks operating with blockchain data and networks. Any person or organisation using Bane should manage their risk appropriately.
Also, I'm not responsible for anything you do with this! Please be careful.

## Contact
wilsonbillkia@gmail.com

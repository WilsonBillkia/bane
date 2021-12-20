

# BaNE(Baremetal Node Erector) v1.0 

## BANE?
Baremetal Node Erector is a toolset for managing Chainlink networks on Ubuntu server. 

You can use BaNE and a few old boxes to turn bare metal (desktop pc's , laptops, what-have-you) into a simple Distributed Oracle Network, or to help provision bare metal servers in data centres.  

The default install creates a class C, NAT'ed  Network consisting of Chainlink nodes, a postgreSQL backend, and an Ethereum node, suitable for a home /test network.  But it is possible to build and manage larger networks.  

Also, Bane is agentless and only requires SSH and Ubuntu (although any flavour of debian should work), so can also extend your operations into amazon ec2, digital ocean droplets, etc, if required.


## Security
Bane supports the deployment of chainlink networks on bare metal. This allows networks to extend outside of cloud providers, with the decentralisation and key management benefits that brings. 

The project was started principally as an alternative to managing nodes using containers.

Just for fun, Bane also audited chainlink nodes against [Department of Defense]( https://public.cyber.mil/stigs/downloads/?_dl_facet_stigs=operating-systems%2Cunix-linux ) security standards using  [Ansible-lockdown](https://github.com/ansible-lockdown/UBUNTU20-CIS)! However this is no longer the case as the StiG roles are only supported on Red Hat, and as nice as granular security reports are, the automation of [ISO 27001](https://www.iso.org/isoiec-27001-information-security.html) preventative controls is the main focus for the time being.   
 

## Social Impact
The project also hopefully has the potential to realise some positive social impact: 
* Can help with re-use of IT assets in developing world into physically secure, community led blockchain projects
* Provides testing & training tools for building cheap blockchain development labs

## Minimum Requirements  
* 3 x Ubuntu Server 20.04 hosts (4 for basic CL redundancy)
* 1 x Management host with ansible (Linux, Mac, or Windows)

NB Any Debian based host should work. 

## Instructions  
WARNING SSH IP connectivity on your nodes is assumed to be restricted to your management host ONLY throughout, or at the very least as taking place on a trusted network. An Internet facing SSH port is possible but definitely not advised.  

This repo does not require any substantial knowledge of ansible to set up a test or training network, though some [orientation](https://docs.ansible.com/) will help.  
Otherwise, ansible skills are essential if running production systems.  Ansible was chosen for it's native, SSH management layer (Polygon has since elected it for their node deployments!) and substantial security controls can be leveraged through adherence to ansible's best practices. 
### Step 1 - Asset Management  
Add your ubuntu server IP addresses to the /etc/ansible/hosts file on your management machine (you should need sudo for this). You can refer to the [hosts_example](../blob/master/hosts_example) file to see the roles used for asset management (node, link, post, geth.) These can be any Ubuntu hosts with IP connectivity and SSH.


Bane builds it's chainlink nodes from source, so you will need the correct versions of NodeJS and Go saved on your management machine. As of Chainlink v 1.01 these are  
* [Node 12.22](https://nodejs.org/dist/latest-v12.x/node-v12.22.7-linux-x64.tar.gz)
* [Go 1.17](https://golang.org/dl/)

Save your node and go installers to the /files directory as node.tar.gz and go.tar.gz respectively. They will then get copied to your nodes if and when required.

BaNE manages environments using the ansible.builtin.lineinfile module to apply configuration to the /etc/environment file. 
To apply your environment variables for ETH_URL etc on the hosts, check out the example settings in link.yml for PATH and GOBIN etc for basic usage of the module.  

### Step 2 - Setup the Network   
 (After this the order of the remaining steps doesn't matter.)  

To build the network: 
```
ansible-playbook node.yml
```
NB If you don't have public keys on your hosts, run the above command with the -kK switch (ansible-playbook -kK node.yml).  This prompts for an ssh (-k) and sudo (-K) password and SCP's your key across for all subsequent authentication.  

The ansible-playbook node command also installs the build requirements from APT (build-essential, libssl-dev, unzip)  

Finally, it uses APT to install screen, htop, tcpdump, and tree. You can alter this list to better reflect your preferred systems management tools by providing the names of the packages you need in the YAML list under roles/sergey/tasks/main.yml  


### Step 2 -Build the Chainlink nodes
 
```
ansible-playbook link.yml
```

link.yml downloads Go and NodeJS, installs them, installs Yarn via APT, clones the chainlink repo, then compiles it from source on each chainlink node.  
 
### Step 3 - Build PostgreSQL nodes

```
ansible-playbook post.yml 
```

This just installs a POSTGRESQL 12 database using APT.  Refer to the official [chainlink](https://docs.chain.link/docs/connecting-to-a-remote-database/) and [Postgresql]((https://www.postgresql.org/docs/12/server-start.html)) guidance for PostgresQL 12 Database setup.

### Step 4 - Build GETH node(s)  

```
ansible-playbook geth.yml 
```
This installs Go Ethereum from the Ubuntu APT. This can then be configured to run as required (eg mainnet / testnet , lightmode, etc) 

## Risk Management & Disclaimer
These tools are based on a free, unqualified analyis of the threats and risks operating with blockchain data and networks. Any person or organisation using Bane should manage their risk appropriately.
Also, I'm not responsible for anything you do with this! Please be careful.

## Contact
wilsonbillkia@gmail.com


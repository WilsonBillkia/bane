

  

# BANE(Baremetal Network Extender) v1.2 

## BANE?
Baremetal Network Extender (previously Baremetal Node Erector) is a toolset for managing Chainlink networks on debian based hosts. 

It deploys chainlink nodes on bare metal, while also playing very well with cloud providers. This enables truly hybrid infrastructure. It also serves as a suitable baseline for security management under ISO27001. It might be useful if you want to build a lab. It will be especially useful if you want to remove containers from the build and management of chainlink networks, or if you want to add bare metal,  old hardware or virtual machines to a chainlink network.

## Social Impact
The project hopefully has the potential to realise some positive social impact: 
* Enables re-use of IT assets in the developing world into physically secure, community led blockchain projects / agricultural / IoT applications, etc.
* Provides testing & training tools for building cheap blockchain development labs for education


## What does this do?
Bane will build chainlink nodes on any suitable linux hosts you specify. It also sets up passwordless authentication to each host for secure management of the estate.

## Security

The project was started principally as an alternative to managing nodes using containers and is made entirely with open source software.


The toolset is designed to comply with ISO 27001 [standards](https://www.iso.org/standard/54534.html) for information security management.  

Some [orientation](https://docs.ansible.com/) in ansible.  

NB! ssh ip connectivity on your nodes is assumed to be restricted to your management host ONLY throughout, or as taking place on a trusted network. An Internet facing ssh port is not advised.   


## Minimum Requirements  
* Chainlink nodes need 2x CPU cores and 4GB RAM 
* Databases need 4x CPU cores, 100GB of storage, and 16GB RAM

NB Any Debian based host should work. Version 1.2 of Bane was tested on Ubuntu Server 22  

Ansible must be installed on your management host. Binaries for NodeJS and Go must be on the management host.

* [NodeJS 16](https://nodejs.org/en/blog/release/v16.16.0)
* [Go 1.21](https://golang.org/dl/)

Save your node and go installers to the files directory as nodejs.tar.gz and go.tar.gz. You can use the http_get_executables.sh shell script to curl them directly to the files folder of the repo, for transfer to link nodes.

## Instructions  


### Asset Management  
Add ip addresses to the hosts file. You can use the example hosts_example.yml file with the ansible-playbook -i switch. 

The link hosts group in the inventory is for chainlink nodes. The postgres group is for building backend PosgreSQL databases.

### Setup the Link Nodes   

```
ansible-playbook link.yml -kK -i hosts_example.yml
```

You only run the above command with the -kK switch (ansible-playbook -kK node.yml) the first time. This prompts for password auth to copy your public keys to the hosts for passwordless authentication.  

This then installs Go and NodeJS and clones the chainlink repo.  
 
### Setup the PostgreSQL nodes

```
ansible-playbook post.yml 
```

This installs a POSTGRESQL 12 database to the hosts of your choice using apt.  Refer to the official [chainlink](https://docs.chain.link/docs/connecting-to-a-remote-database/) and [Postgresql]((https://www.postgresql.org/docs/12/server-start.html)) guidance for PostgresQL 12 Database setup.

Run the disable_ssh_pw_auth.yml playbook to harden ssh from attack. MAKE SURE you have access working with the keys you used first, as this disables password authentication over ssh.

## Risk Management & Disclaimer
These tools are based on a free analyis of the threats and risks operating with blockchain data and networks. Any person or organisation using Bane should manage their risk appropriately.
Also, I'm not responsible for anything you do with this! Please be careful.

## Contact
wilsonbillkia@gmail.com

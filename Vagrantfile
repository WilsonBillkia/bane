# Get Xenial as of 180318

Vagrant.configure("2") do |config|
config.vm.provision "file", source: "~/keys/pub/networkkeypair.pub", destination: "networkkeypair.pub"
#config.vm.provision "shell", inline: "useradd network"
config.vm.provision "shell", inline: "cat networkkeypair.pub >> .ssh/authorized_keys"
#config.ssh.forward_agent = "True"
#config.ssh.keys_only = "True"
#config.ssh.insert_key = "False"
config.ssh.username = "vagrant"
#config.ssh.private_key_path = "keys/priv/networkkeypair"
#config.ssh.verify_host_key = false
config.vm.define "bane" do |bane|
  bane.vm.box = "ubuntu/xenial64"
  bane.vm.box_version = "20180316.0.0"
  bane.vm.network "private_network", ip: "192.168.33.15"
  end
config.vm.define "cia" do |cia|
  cia.vm.box = "ubuntu/xenial64"
  cia.vm.box_version = "20180316.0.0"
  cia.vm.network "private_network", ip: "192.168.33.16"
  end
end

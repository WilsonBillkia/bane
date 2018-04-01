# Get Xenial as of 180318
# swap the key listed here for your own to enable ansible ssh and ssh in general

Vagrant.configure("2") do |config|
config.vm.provision "file", source: "~/keys/pub/networkkeypair.pub", destination: "networkkeypair.pub"
config.vm.provision "shell", inline: "cat networkkeypair.pub >> .ssh/authorized_keys"
config.ssh.username = "vagrant"
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

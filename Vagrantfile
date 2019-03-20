# Bane
# Get Xenial as of 180318 from the Vagrant cloud (Currently locked for compatibility during testing)
# The provisioning commands copy your ssh public key to the guests using the working directory
# which is mounted on the vagrant guests by default.
# swap the key listed here for your own to enable ansible ssh and ssh in general
# /Bane

Vagrant.configure("2") do |config|
config.vm.provision "file", source: "networkkeypair.pub", destination: "~/.ssh/authorized_keys"
config.vm.provision "shell", inline: "sudo systemctl restart sshd.service"
#config.vm.provision "shell", inline: "sudo systemctl restart sshd.service"
#config.ssh.username = "vagrant"
config.ssh.insert_key = false
#config.ssh.keys_only = true
#config.ssh.dsa_authentication = false
config.vm.define "bane" do |bane|
#config.ssh.private_key_path = "/home/network/private/networkkeypair"
config.ssh.private_key_path = "/home/network/private/networkkeypair","~/.vagrant.d/insecure_private_key"
  bane.vm.box = "ubuntu/xenial64"
  bane.vm.box_version = "20180316.0.0"
  bane.vm.network "private_network", ip: "192.168.33.15"
  end
end

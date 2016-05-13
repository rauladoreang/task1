# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

file_to_disk = 'tmp/large_disk.vdi'

$script = <<SCRIPT
echo I am provisioning...
date > /etc/vagrant_provisioned_at
echo Add extra public key
sudo cat /vagrant/authorized_keys >> /home/vagrant/.ssh/authorized_keys
SCRIPT


Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
   config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: "tmp/"

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  config.vm.network "private_network", ip: "192.168.158.4", virtualbox__intnet: "vboxnet2"
  config.vm.provider "virtualbox" do | vb |
    unless File.exist?(file_to_disk)
	vb.customize ['createhd', '--filename', file_to_disk, '--size', 2 * 1024]
    end
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
#    vb.customize ['showvminfo', :id ]
#    vb.customize ['controlvm', :id, 'nic1', 'hostonly', 'vboxnet2' ]  
#    vb.network 
  end

  config.trigger.before :destroy do
    info "Detaching extra hdd"    
  end

  config.vm.provision "shell", inline: $script

  config.vm.provision "shell", inline: <<-SHELL
set -e
set -x

if [ -f /etc/provision_env_disk_added_date ]
then
   echo "Provision runtime already done."
   exit 0
fi


sudo fdisk -u /dev/sdb <<EOF
n
p
1


w
EOF

mkfs.ext4 /dev/sdb1
mkdir -p /data
mount -t ext4 /dev/sdb1 /data

date > /etc/provision_env_disk_added_date
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    echo Well done
  SHELL

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "apache.yml"
#    ansible.verbose = true
#    ansible.install = true
  end

end


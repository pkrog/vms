# vi: ft=ruby sw=0 ts=2 et fdm=marker

# Main {{{1
################################################################

Vagrant.configure(2) do |config|
  
  config.vagrant.plugins = "vagrant-alpine" # For setting hostname on alpine
  
  # averell {{{2
  ################################################################
  
  config.vm.define "averell" do |averell|
    averell.vm.box = "generic/freebsd12"
    averell.vm.hostname = "averell"
    averell.vm.provider :virtualbox do |vb|
      vb.name = 'averell'
    end
    averell.vm.provision "Install Python.", type: "shell", privileged: true, inline: "pkg install -y python" # Needed by Ansible
    averell.vm.provision :ansible do |ansible|
      ansible.extra_vars = {
        ansible_python_interpreter: "python3"
      }
      ansible.playbook = "provisioning/playbook.yml"
    end
  end

  # jack {{{2
  ################################################################
  
  config.vm.define "jack" do |jack|
    jack.vm.box = "archlinux/archlinux"
    jack.vm.hostname = "jack"
    jack.vm.provider :virtualbox do |vb|
      vb.name = 'jack'
    end
    jack.vm.provision "Install Python.", type: "shell", privileged: true, inline: "pacman -S --noconfirm extra/python" # Needed by Ansible
    jack.vm.provision :ansible do |ansible|
      ansible.extra_vars = {
        ansible_python_interpreter: "python3"
      }
      ansible.playbook = "provisioning/playbook.yml"
    end
  end
  
  # asterix {{{2
  ################################################################
  
  config.vm.define "asterix" do |asterix|
    asterix.vm.box = "generic/gentoo"
    asterix.vm.hostname = "asterix"
    asterix.vm.provider :virtualbox do |vb|
      vb.name = 'asterix'
    end
#    asterix.vm.provision "Install Python.", type: "shell", privileged: true, inline: "pacman -S extra/python" # Needed by Ansible
    asterix.vm.provision :ansible do |ansible|
      ansible.extra_vars = {
        ansible_python_interpreter: "python3"
      }
      ansible.playbook = "provisioning/playbook.yml"
    end
  end
  
  # jollyjumper {{{2
  ################################################################
  
  config.vm.define "jollyjumper" do |jollyjumper|
    jollyjumper.vm.box = "generic/alpine38"
    jollyjumper.vm.guest = :alpine # Needed to set hostname. Inside the box generic/alpine38, the guest is set to "alt" (which is wrong).
    jollyjumper.vm.hostname = "jollyjumper"
    jollyjumper.vm.provider :virtualbox do |vb|
      vb.name = 'jollyjumper'
    end
    jollyjumper.vm.provision "Install Python.", type: "shell", privileged: true, inline: "apk add python3" # Needed by Ansible
    jollyjumper.vm.provision :ansible do |ansible|
      ansible.extra_vars = {
        ansible_python_interpreter: "python3"
      }
      ansible.playbook = "provisioning/playbook.yml"
    end
  end

  # rantanplan {{{2
  ################################################################
  
  config.vm.define "rantanplan" do |rantanplan|
    rantanplan.vm.box = "ubuntu/bionic64"
    rantanplan.vm.hostname = "rantanplan"
    rantanplan.vm.provider :virtualbox do |vb|
      vb.name = 'rantanplan'
    end
    rantanplan.vm.provision :ansible do |ansible|
      ansible.extra_vars = {
        ansible_python_interpreter: "python3"
      }
      ansible.playbook = "provisioning/playbook.yml"
    end
  end
  
end

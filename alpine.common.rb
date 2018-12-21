# vi: ft=ruby sw=0 ts=2 et fdm=marker

# Info {{{1
################################################################

def info(msg)
  puts "------------------------ [INFO] #{msg}"
end

# Name VM from Vagrantfile name {{{1
################################################################

def name_vm_from_vagrantfile_name(config)
  if ! ENV['VAGRANT_VAGRANTFILE'].nil?
    if /^(.*)\.vagrant$/ =~ ENV['VAGRANT_VAGRANTFILE']
      vm_name = $1
      info("Set VM name to \"#{vm_name}\".")
      config.vm.define vm_name
      config.vm.provider :virtualbox do |vb|
        vb.name = vm_name
      end
    end
  end
end

# Install personal configuration {{{1
################################################################

def install_personal_config(config)
  info("Install personal configuration.")
  config.vm.provision "Install Less.", type: "shell", privileged: true, inline: "apk add less" # To have colors working fine with git, since git uses less for outputing to terminal. Busybox's less does not have the -R option.
  
#  config.vm.provision "Install Git.", type: "shell", privileged: true, inline: "apk add git"
# Gives error:
#   jollyjumper: (1/9) Installing libcrypto1.1 (1.1.1a-r1)
#       jollyjumper: ERROR:
#             jollyjumper: libcrypto1.1-1.1.1a-r1: trying to overwrite etc/ssl/openssl.cnf owned by libressl2.6-libcrypto
#           jollyjumper: -2.6.4-r0.
             

  config.vm.provision "Install Make.", type: "shell", privileged: true, inline: "apk add make"
  config.vm.provision "Install Screen.", type: "shell", privileged: true, inline: "apk add screen"
  config.vm.provision "Install Vim.", type: "shell", privileged: true, inline: "apk add vim"
  config.vm.provision "Install Man.", type: "shell", privileged: true, inline: "apk add man man-pages"
  config.vm.provision "Create dev folder.", type: "shell", privileged: false, inline: "mkdir -p dev"
  config.vm.provision "Clone public configuration.", type: "shell", privileged: false, inline: "cd dev && git clone --recursive https://github.com/pkrog/public-config"
  config.vm.provision "Install public configuration.", type: "shell", privileged: false, inline: "cd dev/public-config && make install"
  config.vm.provision "Clone public notes.", type: "shell", privileged: false, inline: "cd dev && git clone https://github.com/pkrog/public-notes"
end

# Install R package development framework {{{1
################################################################

def install_r_pkg_dev_framework(config)
  info("Install R package development framework.")
  config.vm.provision "Install gcc.", type: "shell", privileged: true, inline: "apk add gcc"
  config.vm.provision "Install g++.", type: "shell", privileged: true, inline: "apk add g++"
  config.vm.provision "Install R.", type: "shell", privileged: true, inline: "apk add R R-dev"
end

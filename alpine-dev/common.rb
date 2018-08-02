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

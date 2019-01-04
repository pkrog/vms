# vi: fdm=marker
	
# Constants {{{1
################################################################

$os_info = {
	'alpine' => {
		'update' => 'apk update',
		'install' => 'apk add',
		'pkg' => {
			'R' => 'R R-dev',
			'man' => 'man man-pages'
		}
	},
	'ubuntu' => {
		'update' => 'apt-get update',
		'install' => 'apt-get install -y --no-install-recommends',
		'pkg' => {
			'R' => 'r-base',
			'linux-headers' => nil,
			'zlib-dev' => 'zlib1g-dev',
			'libcurl-dev' => 'libcurl4-openssl-dev'
		}
	}
}

# Info {{{1
################################################################

def info(config, msg)
  	config.vm.provision "shell", inline: "echo ------------------------ [INFO] #{msg}"
end

# Name VM from Vagrantfile name {{{1
################################################################

def name_vm_from_vagrantfile_name(config)
  if ! ENV['VAGRANT_VAGRANTFILE'].nil?
    if /^(.*)\.vagrant$/ =~ ENV['VAGRANT_VAGRANTFILE']
      vm_name = $1
      info(config, "Set VM name to \"#{vm_name}\".")
      config.vm.define vm_name
      config.vm.provider :virtualbox do |vb|
        vb.name = vm_name
      end
    end
  end
end

# Install biodb package sources {{{1
################################################################

def install_biodb_dev(config)
	info(config, "Install biodb sources for development.")
	config.vm.provision "Clone biodb.", type: "shell", privileged: false, inline: "cd dev && git clone https://github.com/pkrog/biodb"
	config.vm.provision "Install biodb dependencies.", type: "shell", privileged: false, inline: "cd dev/biodb && make install.deps"
end

# Update package manager {{{1
################################################################

def update_package_manager(config)
	
	info(config, "Update list of packages.")

	# Check OS
	if not $os_info.key?($os)
		raise "Unknown OS #{$os}."
	end
	
	config.vm.provision "Package manager update.", type: "shell", privileged: true, inline: $os_info[$os]['update']
end

# Install package {{{1
################################################################

def install_packages(config, pkgs)

	# Check OS
	if not $os_info.key?($os)
		raise "Unknown OS #{$os}."
	end
	
	# Check pgks type
	if pkgs.kind_of?(String)
		pkgs = [pkgs]
	end

	# Loop on all packages
	for pkg in pkgs
		info(config, "Install package #{pkg}.")
		
		# Get right package name
		if $os_info[$os]['pkg'].key?(pkg)
			pkg = $os_info[$os]['pkg'][pkg]
		end

		# Install package
		if not pkg.nil?
			config.vm.provision "Install #{pkg} package.", type: "shell", privileged: true, inline: $os_info[$os]['install'] + ' ' + pkg
		end
	end
end

# Install personal configuration {{{1
################################################################

def install_personal_config(config)
	info(config, "Install personal configuration.")
	install_packages(config, 'less') # To have colors working fine with git, since git uses less for outputing to terminal. Busybox's less does not have the -R option.
	install_packages(config, ['git', 'make', 'screen', 'vim', 'man'])

	config.vm.provision "Create dev folder.", type: "shell", privileged: false, inline: "mkdir -p dev"
	config.vm.provision "Clone public configuration.", type: "shell", privileged: false, inline: "cd dev && git clone --recursive https://github.com/pkrog/public-config"
	config.vm.provision "Install public configuration.", type: "shell", privileged: false, inline: "cd dev/public-config && make install"
	config.vm.provision "Clone public notes.", type: "shell", privileged: false, inline: "cd dev && git clone https://github.com/pkrog/public-notes"
end

# Install R package development framework {{{1
################################################################

def install_r_pkg_dev_framework(config)
	
	info(config, "Install R package development framework.")

	install_packages(config, ['gcc', 'g++'])

	if $os == 'ubuntu'
		# Install most recent R package
		config.vm.provision "Install new package repos.", type: "shell", privileged: true, inline: "sed -i -e '$adeb http://cran.univ-paris1.fr/bin/linux/ubuntu #{$os_version}-cran35/' /etc/apt/sources.list"
		config.vm.provision "Install package repos key.", type: "shell", privileged: true, inline: "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9"
		update_package_manager(config)
	end
	install_packages(config, 'R')
	
	install_packages(config, ['linux-headers', 'libxml2-dev', 'zlib-dev', 'libcurl-dev', 'gfortran', 'libblas-dev', 'liblapack-dev'])
  
	config.vm.provision "Install devtools.", type: "shell", privileged: true, inline: 'R -e \'install.packages("devtools", dependencies = TRUE, repos = "https://cloud.r-project.org/")\''
end

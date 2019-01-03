MACHINES=jollyjumper rantanplan

all:

# W4M-VM machines {{{1
################################################################

joe: joe.up

joe.up:
	cd w4m-vm && ./build-vm --name joe --wait -t lcmsmatching

joe.clean:
	cd w4m-vm && W4MVM_NAME=joe vagrant destroy -f

joe.halt:
	cd w4m-vm && W4MVM_NAME=joe vagrant halt -f

joe.ssh:
	cd w4m-vm && W4MVM_NAME=joe vagrant ssh -f

# Machines {{{1
################################################################

$(MACHINES): %: %.up

$(addsuffix .ssh,$(MACHINES)): %.ssh: .vagrant/machines/%/virtualbox/id
	VAGRANT_VAGRANTFILE=$(basename $@).vagrant vagrant ssh

$(addsuffix .halt,$(MACHINES)): %.halt: .vagrant/machines/%/virtualbox/id
	VAGRANT_VAGRANTFILE=$(basename $@).vagrant vagrant halt

$(addsuffix .up,$(MACHINES)): %.up: .vagrant/machines/%/virtualbox/id

.vagrant/machines/%/virtualbox/id: %.vagrant
	VAGRANT_VAGRANTFILE=$< vagrant up

$(addsuffix .rebuild,$(MACHINES)): %.rebuild: %.clean %.up

%.clean:
	VAGRANT_VAGRANTFILE=$(basename $@).vagrant vagrant destroy -f
	[ -z "$$(VBoxManage list vms | grep ^.$(basename $@))" ] || VBoxManage unregistervm --delete $(basename $@)

clean: $(addsuffix .clean,$(MACHINES))

.PHONY: all clean jollyjumper

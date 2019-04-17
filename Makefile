MACHINES=jollyjumper rantanplan averell
W4M_MACHINES=joe william

all:

# W4M-VM machines {{{1
################################################################

joe_args=
william_args=--prod

$(W4M_MACHINES): %: %.up

$(addsuffix .up,$(W4M_MACHINES)): %.up:
	cd w4m-vm && ./build-vm --name $(basename $@) --wait -t lcmsmatching $(value $(basename $@)_args)

$(addsuffix .clean,$(W4M_MACHINES)): %.clean:
	cd w4m-vm && W4MVM_NAME=$(basename $@) vagrant destroy -f

$(addsuffix .halt,$(W4M_MACHINES)): %.halt:
	cd w4m-vm && W4MVM_NAME=$(basename $@) vagrant halt -f

$(addsuffix .ssh,$(W4M_MACHINES)): %.ssh:
	cd w4m-vm && W4MVM_NAME=$(basename $@) vagrant ssh -f

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

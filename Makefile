MACHINES=jollyjumper abraracourcix
W4M_MACHINES=joe william

all:

crocodiles:
	./macos_vm -b -n crocodiles

crocodiles.clean:
	./macos_vm -d -n crocodiles

luckyluke:
	./win10_vm -b -n luckyluke

luckyluke.clean:
	./win10_vm -d -n luckyluke

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
	vagrant ssh $(patsubst %.ssh,%,$@)

$(addsuffix .halt,$(MACHINES)): %.halt: .vagrant/machines/%/virtualbox/id
	vagrant halt $(patsubst %.halt,%,$@)

$(addsuffix .up,$(MACHINES)): %.up: .vagrant/machines/%/virtualbox/id

.vagrant/machines/%/virtualbox/id: Vagrantfile
	vagrant up $(patsubst .vagrant/machines/%/virtualbox/id,%,$@)

$(addsuffix .rebuild,$(MACHINES)): %.rebuild: %.clean %.up

%.clean:
	vagrant destroy -f $(patsubst %.clean,%,$@)
	[ -z "$$(VBoxManage list vms | grep ^.$(basename $@))" ] || VBoxManage unregistervm --delete $(basename $@)

clean: $(addsuffix .clean,$(MACHINES))

.PHONY: all clean jollyjumper crocodiles

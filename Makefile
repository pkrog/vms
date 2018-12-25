MACHINES=jollyjumper rantanplan

all:

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
	[ -z "$$(VBoxManage list vms | grep $(basename $@))" ] || VBoxManage unregistervm --delete $(basename $@)

clean: $(addsuffix .clean,$(MACHINES))

.PHONY: all clean jollyjumper

MACHINES=jollyjumper

all:

$(MACHINES): %: .vagrant/machines/%/virtualbox/id

%.up: .vagrant/machines/%/virtualbox/id

.vagrant/machines/%/virtualbox/id: %.vagrant
	VAGRANT_VAGRANTFILE=$< vagrant up

%.rebuild: %.clean %.up

%.clean:
	VAGRANT_VAGRANTFILE=$(basename $@).vagrant vagrant destroy -f
	[ -z "$$(VBoxManage list vms | grep $(basename $@))" ] || VBoxManage unregistervm --delete $(basename $@)

clean: $(addsuffix .clean,$(MACHINES))

.PHONY: all clean jollyjumper

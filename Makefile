all:

jollyjumper: VM_NAME=jollyjumper
jollyjumper:
	cd alpine-dev && vagrant destroy -f $@
	cd alpine-dev && vagrant up $@

clean:

.PHONY: all clean

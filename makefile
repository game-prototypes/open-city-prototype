# Basic Makefile
# by @angrykoala

main: test


.PHONY: test
test:
	godot3 --no-window -s addons/gut/gut_cmdln.gd -d

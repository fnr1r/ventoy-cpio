HERE := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))

THIS_MK := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

SCRIPTS_DIR := $(THIS_MK)

undefine THIS_MK

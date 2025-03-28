THIS_MK := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

ifndef HERE
HERE := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
endif

ifndef SCRIPTS_DIR
SCRIPTS_DIR := $(THIS_MK)
export SCRIPTS_DIR
endif

ifndef REPO_DIR
REPO_DIR := $(patsubst %/,%,$(dir $(SCRIPTS_DIR)))
export REPO_DIR
endif

undefine THIS_MK

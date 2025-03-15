# This is a hack to not print
IS_BUILT_DIR := .is_built.d

$(IS_BUILT_DIR):
	mkdir -p $@

# Defines a Makefile and adds it as a dependency of submakes
#
# arg1: id
# arg2: path
# arg3: target name (optional)
# arg4: which target to add to (optional)
define add_submake_hack
$(eval
$1_TARGET := $(if $3,$3,$1)
)
$(eval
$(IS_BUILT_DIR)/$1:
	+$(MAKE) -C $2
.PHONY: $($1_TARGET)
$($1_TARGET): $(IS_BUILT_DIR)/$1
$(if $4, $4, submakes): $($1_TARGET) | $(IS_BUILT_DIR)
)
$(shell \
if $(MAKE) -C "$2" -q > /dev/null; then \
	if ! [ -f $(IS_BUILT_DIR)/$1 ]; then \
		touch $(IS_BUILT_DIR)/$1; \
	fi \
elif [ -f "$(IS_BUILT_DIR)/$1" ]; then \
	rm $(IS_BUILT_DIR)/$1; \
fi \
)
$(eval
undefine $1_TARGET
)
endef

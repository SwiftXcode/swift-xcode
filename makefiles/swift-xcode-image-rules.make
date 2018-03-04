# Makefile
# Copyright © 2018 ZeeZide GmbH. All rights reserved.

ifeq ($(MKDIR_P),)
  SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
  include $(SELF_DIR)swift-xcode-config.make
endif

# entry points

all :: build-image

clean :: clean-image

distclean :: clean
	rm -rf .build Package.resolved


install :: all install-templates install-image

uninstall :: uninstall-templates uninstall-image

lint :: lint-templates


# image

# SWIFT_XCODE_IMAGING=yes swift xcode build
build-image ::
	SA_IMAGE=$(PACKAGE) swift xcode image

clean-image ::
	swift xcode clean

install-image :: all make-abi-install-dir
	$(INSTALL) $(PACKAGE_TARBALL) $(SWIFT_ABI_LIB_INSTALL_DIR)/$(PACKAGE_TARBALL_NAME)
	( cd $(SWIFT_ABI_LIB_INSTALL_DIR); \
	  ln -sf $(PACKAGE_TARBALL_NAME) $(PACKAGE_TARBALL_LATEST) )

uninstall-image ::
	rm -f "$(SWIFT_ABI_LIB_INSTALL_DIR)/$(PACKAGE_TARBALL_NAME)"
	rm -f "$(SWIFT_ABI_LIB_INSTALL_DIR)/$(PACKAGE_TARBALL_LATEST)"

make-abi-install-dir ::
	$(MKDIR_P) $(SWIFT_ABI_LIB_INSTALL_DIR)


# templates
#
#   this is a little crappy, but I couldn't figure our how to deal properly
#   with spaces in Makefiles ;-)

lint-templates ::

install-templates :: lint-templates

uninstall-templates ::

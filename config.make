# Makefile
# Copyright © 2018 ZeeZide GmbH. All rights reserved.

ifeq ($(prefix),)
  prefix=/usr/local
endif

STATIC_LIBRARY_PREFIX=lib
STATIC_LIBRARY_SUFFIX=.a

MKDIR_P     = mkdir -p
INSTALL     = cp
INSTALL_R   = cp -r
UNINSTALL   = rm -f
UNINSTALL_R = rm -rf
XML_LINTER  = xmllint >/dev/null

# Darwin, x86_64
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Darwin)
else
  $(error "only makes sense on Darwin ;-)")
endif

PLATFORM_PREFERRED_ARCH = $(shell uname -m)
CURRENT_ARCH            = $(PLATFORM_PREFERRED_ARCH)



# We have set prefix above, or we got it via ./config.make
# Now we need to derive:
# - XCCONFIG_INSTALL_DIR          e.g. /usr/lib/xcconfig
# - BINARY_INSTALL_DIR            e.g. /usr/bin
# - XCODE_TEMPLATE_INSTALL_DIR

ifeq ($(BINARY_INSTALL_DIR),)
  BINARY_INSTALL_DIR=$(prefix)/bin
endif

ifeq ($(UNAME_S),Darwin)
  ifeq ($(XCCONFIG_INSTALL_DIR),)
    XCCONFIG_INSTALL_DIR=$(prefix)/lib/xcconfig
  endif

  ifeq ($(XCODE_TEMPLATE_SOURCE_DIR),)
    XCODE_TEMPLATE_SOURCE_DIR=$(prefix)/lib/xcode/templates
  endif
  ifeq ($(XCODE_TEMPLATE_INSTALL_DIR),)
    XCODE_TEMPLATE_INSTALL_DIR=$(HOME)/Library/Developer/Xcode/Templates
  endif
  
  XCODE_TEMPLATE_PROJECT_APP_SOURCE_DIR     = $(prefix)/lib/xcode/templates/Project\ Templates/Application
  XCODE_TEMPLATE_PROJECT_BASE_SOURCE_DIR    = $(prefix)/lib/xcode/templates/Project\ Templates/Base
  XCODE_TEMPLATE_PROJECT_MODULES_SOURCE_DIR = $(prefix)/lib/xcode/templates/Project\ Templates/SPM\ Modules
  XCODE_TEMPLATE_FILE_OTHER_SOURCE_DIR      = $(prefix)/lib/xcode/templates/File\ Templates/Other
  
  XCODE_DIR=/Applications/Xcode.app
  XCODE_PLATFORMS_RELDIR=Contents/Developer/Platforms
  XCODE_IPHONEOS_TEMPLATES_DIR=$(XCODE_DIR)/$(XCODE_PLATFORMS_RELDIR)/iPhoneOS.platform/Developer/Library/Xcode/Templates
  XCODE_IPHONEOS_TEMPLATES_APP_SINGLE_VIEW=$(XCODE_IPHONEOS_TEMPLATES_DIR)/Project\ Templates/iOS/Application/Single\ View\ App.xctemplate
  XCODE_IPHONEOS_TEMPLATES_APP_COCOA_TOUCH_BASE=$(XCODE_IPHONEOS_TEMPLATES_DIR)/Project\ Templates/iOS/Application/Cocoa\ Touch\ App\ Base.xctemplate
endif

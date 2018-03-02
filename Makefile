# Makefile
# Copyright 2017-2018 ZeeZide GmbH. All rights reserved.

-include config.make

PROJECT_APP_TEMPLATES_DIR = templates/Project\ Templates/Application
PROJECT_BASE_TEMPLATES_DIR = templates/Project\ Templates/Base
PROJECT_MODULES_TEMPLATES_DIR = templates/Project\ Templates/SPM\ Modules
FILE_OTHER_TEMPLATES_DIR  = templates/File\ Templates/Other

SCRIPTS = $(wildcard scripts/swift-xcode*)

all :

clean :

distclean : clean


install : all install-templates install-xcconfig
	$(MKDIR_P) $(BINARY_INSTALL_DIR)
	$(INSTALL) $(SCRIPTS) $(BINARY_INSTALL_DIR)/

uninstall : uninstall-templates uninstall-xcconfig
	$(UNINSTALL) $(addprefix $(BINARY_INSTALL_DIR)/,$(notdir $(SCRIPTS)))
	
lint : lint-templates


# templates
#
#   this is a little crappy, but I couldn't figure our how to deal properly
#   with spaces in Makefiles ;-)

lint-templates :
	$(XML_LINTER) $(FILE_OTHER_TEMPLATES_DIR)/Package\ Manifest.xctemplate/TemplateInfo.plist
	$(XML_LINTER) $(PROJECT_MODULES_TEMPLATES_DIR)/SPM\ Cows\ Module.xctemplate/TemplateInfo.plist
	$(XML_LINTER) $(PROJECT_MODULES_TEMPLATES_DIR)/SPM\ UXKit\ Module.xctemplate/TemplateInfo.plist
	$(XML_LINTER) $(PROJECT_MODULES_TEMPLATES_DIR)/SPM\ CryptoSwift\ Module.xctemplate/TemplateInfo.plist
	$(XML_LINTER) $(PROJECT_MODULES_TEMPLATES_DIR)/SPM\ PromiseKit\ Module.xctemplate/TemplateInfo.plist
	$(XML_LINTER) $(PROJECT_MODULES_TEMPLATES_DIR)/SPM\ Regex\ Module.xctemplate/TemplateInfo.plist
	$(XML_LINTER) $(PROJECT_BASE_TEMPLATES_DIR)/Swift\ iOS\ Base.xctemplate/TemplateInfo.plist
	$(XML_LINTER) $(PROJECT_BASE_TEMPLATES_DIR)/SPM\ iOS\ Base.xctemplate/TemplateInfo.plist
	$(XML_LINTER) $(PROJECT_BASE_TEMPLATES_DIR)/SPM\ Tool\ Base.xctemplate/TemplateInfo.plist
	$(XML_LINTER) $(PROJECT_APP_TEMPLATES_DIR)/Swift\ Package\ Manager\ App.xctemplate/TemplateInfo.plist
	$(XML_LINTER) $(PROJECT_APP_TEMPLATES_DIR)/Swift\ Package\ Manager\ Tool.xctemplate/TemplateInfo.plist

install-templates : lint-templates \
	install-file-other-templates		\
	install-project-modules-templates	\
	install-project-base-templates		\
	install-project-app-templates
	./scripts/swift-xcode-link-templates --replacedirs

uninstall-templates : \
	uninstall-file-other-templates		\
	uninstall-project-modules-templates	\
	uninstall-project-base-templates	\
	uninstall-project-app-templates
	./scripts/swift-xcode-link-templates --deletelinks


install-project-modules-templates : uninstall-project-modules-templates
	$(MKDIR_P) $(XCODE_TEMPLATE_PROJECT_MODULES_SOURCE_DIR)
	$(INSTALL_R) \
		$(PROJECT_MODULES_TEMPLATES_DIR)/SPM\ Cows\ Module.xctemplate		\
		$(PROJECT_MODULES_TEMPLATES_DIR)/SPM\ UXKit\ Module.xctemplate		\
		$(PROJECT_MODULES_TEMPLATES_DIR)/SPM\ CryptoSwift\ Module.xctemplate	\
		$(PROJECT_MODULES_TEMPLATES_DIR)/SPM\ PromiseKit\ Module.xctemplate	\
		$(PROJECT_MODULES_TEMPLATES_DIR)/SPM\ Regex\ Module.xctemplate	\
		$(XCODE_TEMPLATE_PROJECT_MODULES_SOURCE_DIR)/

uninstall-project-modules-templates :
	$(UNINSTALL_R) \
		$(XCODE_TEMPLATE_PROJECT_MODULES_SOURCE_DIR)/SPM\ Cows\ Module.xctemplate	\
		$(XCODE_TEMPLATE_PROJECT_MODULES_SOURCE_DIR)/SPM\ UXKit\ Module.xctemplate	\
		$(XCODE_TEMPLATE_PROJECT_MODULES_SOURCE_DIR)/SPM\ CryptoSwift\ Module.xctemplate\
		$(XCODE_TEMPLATE_PROJECT_MODULES_SOURCE_DIR)/SPM\ PromiseKit\ Module.xctemplate	\
		$(XCODE_TEMPLATE_PROJECT_MODULES_SOURCE_DIR)/SPM\ Regex\ Module.xctemplate


install-project-app-templates : uninstall-project-app-templates
	$(MKDIR_P) $(XCODE_TEMPLATE_PROJECT_APP_SOURCE_DIR)
	$(INSTALL_R) \
		$(PROJECT_APP_TEMPLATES_DIR)/Swift\ Package\ Manager\ App.xctemplate \
		$(PROJECT_APP_TEMPLATES_DIR)/Swift\ Package\ Manager\ Tool.xctemplate \
		$(XCODE_TEMPLATE_PROJECT_APP_SOURCE_DIR)/
	$(INSTALL_R) \
		$(XCODE_IPHONEOS_TEMPLATES_APP_SINGLE_VIEW)/Main.storyboard \
		$(XCODE_TEMPLATE_PROJECT_APP_SOURCE_DIR)/Swift\ Package\ Manager\ App.xctemplate/

uninstall-project-app-templates :
	$(UNINSTALL_R) \
		$(XCODE_TEMPLATE_PROJECT_APP_SOURCE_DIR)/Swift\ Package\ Manager\ App.xctemplate \
		$(XCODE_TEMPLATE_PROJECT_APP_SOURCE_DIR)/Swift\ Package\ Manager\ Tool.xctemplate

install-project-base-templates : uninstall-project-base-templates
	$(MKDIR_P) $(XCODE_TEMPLATE_PROJECT_BASE_SOURCE_DIR)
	$(INSTALL_R) \
		$(PROJECT_BASE_TEMPLATES_DIR)/Swift\ iOS\ Base.xctemplate\
		$(PROJECT_BASE_TEMPLATES_DIR)/SPM\ iOS\ Base.xctemplate	\
		$(PROJECT_BASE_TEMPLATES_DIR)/SPM\ Tool\ Base.xctemplate\
		$(XCODE_TEMPLATE_PROJECT_BASE_SOURCE_DIR)/
	$(INSTALL_R) \
		$(XCODE_IPHONEOS_TEMPLATES_APP_COCOA_TOUCH_BASE)/Images.xcassets	\
		$(XCODE_IPHONEOS_TEMPLATES_APP_COCOA_TOUCH_BASE)/LaunchScreen.storyboard\
		$(XCODE_TEMPLATE_PROJECT_BASE_SOURCE_DIR)/Swift\ iOS\ Base.xctemplate/

uninstall-project-base-templates :
	$(UNINSTALL_R) \
		$(XCODE_TEMPLATE_PROJECT_BASE_SOURCE_DIR)/Swift\ iOS\ Base.xctemplate	\
		$(XCODE_TEMPLATE_PROJECT_BASE_SOURCE_DIR)/SPM\ iOS\ Base.xctemplate	\
		$(XCODE_TEMPLATE_PROJECT_BASE_SOURCE_DIR)/SPM\ Tool\ Base.xctemplate


install-file-other-templates : uninstall-file-other-templates
	$(MKDIR_P) $(XCODE_TEMPLATE_FILE_OTHER_SOURCE_DIR)
	$(INSTALL_R) \
	  $(FILE_OTHER_TEMPLATES_DIR)/Package\ Manifest.xctemplate \
	  $(XCODE_TEMPLATE_FILE_OTHER_SOURCE_DIR)/

uninstall-file-other-templates :
	$(UNINSTALL_R) $(XCODE_TEMPLATE_FILE_OTHER_SOURCE_DIR)/Package\ Manifest.xctemplate


# xcconfig

install-xcconfig:
	$(MKDIR_P) $(XCCONFIG_INSTALL_DIR)
	$(INSTALL) swift-xcode.xcconfig $(XCCONFIG_INSTALL_DIR)/swift-xcode.xcconfig

uninstall-xcconfig:
	$(UNINSTALL) $(XCCONFIG_INSTALL_DIR)/swift-xcode.xcconfig

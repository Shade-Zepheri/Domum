include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = domum
domum_FILES = DOMRootListController.m DOMAboutController.m DOMOptionsController.m
domum_INSTALL_PATH = /Library/PreferenceBundles
domum_FRAMEWORKS = UIKit
domum_PRIVATE_FRAMEWORKS = Preferences
domum_CFLAGS = -Wno-deprecated-declarations -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/domum.plist$(ECHO_END)

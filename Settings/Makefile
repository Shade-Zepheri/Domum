include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Domum
Domum_FILES = $(wildcard *.m)
Domum_INSTALL_PATH = /Library/PreferenceBundles
Domum_CFLAGS = -Wno-deprecated-declarations
Domum_FRAMEWORKS = UIKit
Domum_PRIVATE_FRAMEWORKS = Preferences
Domum_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Domum.plist$(ECHO_END)

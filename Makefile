export TARGET = iphone:9.2

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Domum
Domum_FILES = $(wildcard *.x) $(wildcard *.m)
Domum_FRAMEWORKS = UIKit
Domum_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
Domum_CFLAGS = -fobjc-arc

BUNDLE_NAME = Domum-Resources
Domum-Resources_INSTALL_PATH = /var/mobile/Library/

SUBPROJECTS = domum

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

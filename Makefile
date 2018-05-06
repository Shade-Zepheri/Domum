export TARGET = iphone:10.1:9.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Domum
Domum_FILES = $(wildcard *.x) $(wildcard *.m)
Domum_FRAMEWORKS = UIKit
Domum_EXTRA_FRAMEWORKS = Cephei
Domum_CFLAGS = -fobjc-arc -IHeaders

BUNDLE_NAME = Domum-Resources
Domum-Resources_INSTALL_PATH = /var/mobile/Library/

SUBPROJECTS = Settings

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

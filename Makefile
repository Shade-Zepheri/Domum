include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Domum
Domum_FILES = $(wildcard tweak/*.m tweak/*.mm tweak/*.x tweak/*.xm)
Domum_FRAMEWORKS = UIKit
Domum_LIBRARIES = activator
Domum_CFLAGS = -fobjc-arc
ADDITIONAL_OBJCFLAGS = -fobjc-arc

BUNDLE_NAME = Default
Default_INSTALL_PATH = /Library/Application Support/Domum/

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += domum
include $(THEOS_MAKE_PATH)/aggregate.mk

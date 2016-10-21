include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Domum
Domum_FILES = $(wildcard tweak/*.m tweak/*.mm tweak/*.x tweak/*.xm)
Domum_FRAMEWORKS = UIKit
Domum_LIBRARIES = activator colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += domum
include $(THEOS_MAKE_PATH)/aggregate.mk

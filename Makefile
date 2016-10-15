include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Domum
Domum_FILES = Tweak.xm
Domum_FRAMEWORKS = IOKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += domum
include $(THEOS_MAKE_PATH)/aggregate.mk

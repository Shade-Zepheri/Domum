CFLAGS = -fobjc-arc -O2
TARGET = iphone:9.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Domum
Domum_FILES = $(wildcard tweak/*.m tweak/*.x tweak/*.xm)
Domum_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += domum
include $(THEOS_MAKE_PATH)/aggregate.mk

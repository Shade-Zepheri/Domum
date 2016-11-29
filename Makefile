TARGET = iphone:clang:9.3:9.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Domum
Domum_FILES = tweak/DomWindow.x tweak/Tweak.xm
Domum_FRAMEWORKS = UIKit
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += domum
include $(THEOS_MAKE_PATH)/aggregate.mk

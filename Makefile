TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_DEVICE_IP = localhost
ARCHS = arm64
PACKAGE_VERSION = 1.0.0
TARGET_CODESIGN = ldid

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardTheme

KeyboardTheme_FILES = Tweak.xm
KeyboardTheme_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

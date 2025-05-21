ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm Settings/KBTRootListController.m Settings/ThemeManager.m
KeyboardTheme_CFLAGS = -fobjc-arc
KeyboardTheme_FRAMEWORKS = UIKit Foundation Preferences
ADDITIONAL_OBJCFLAGS = -I./Settings

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/tweak.mk

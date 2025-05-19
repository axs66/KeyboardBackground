ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:16.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm Settings/KBTRootListController.m
KeyboardTheme_FRAMEWORKS = UIKit CoreGraphics
KeyboardTheme_PRIVATE_FRAMEWORKS = Preferences    # 加入这一行

include $(THEOS_MAKE_PATH)/tweak.mk

INSTALL_TARGET_PROCESSES = SpringBoard

after-install::
	install.exec "killall -9 SpringBoard"

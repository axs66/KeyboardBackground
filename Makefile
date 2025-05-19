ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:16.0

include $(THEOS)/makefiles/common.mk

PACKAGE_VERSION = 1.0.0
TARGET_CODESIGN = ldid

TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm Settings/KBTRootListController.m
KeyboardTheme_FRAMEWORKS = UIKit CoreGraphics
KeyboardTheme_PRIVATE_FRAMEWORKS = AppSupport

# 如果依然报找不到 AppSupport 框架，可以试试加这行（私有框架路径）
# ADDITIONAL_LDFLAGS += -F$(THEOS)/sdks/iPhoneOS.sdk/System/Library/PrivateFrameworks

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

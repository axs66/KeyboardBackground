ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:16.0

include $(THEOS)/makefiles/common.mk

PACKAGE_VERSION = 1.0.0
INSTALL_TARGET_PROCESSES = SpringBoard

# tweak 设置
TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm
KeyboardTheme_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

# 设置面板独立为一个 bundle
BUNDLE_NAME = KeyboardThemeSettings
KeyboardThemeSettings_FILES = Settings/KBTRootListController.m
KeyboardThemeSettings_INSTALL_PATH = /Library/PreferenceBundles
KeyboardThemeSettings_FRAMEWORKS = UIKit
KeyboardThemeSettings_PRIVATE_FRAMEWORKS = Preferences
KeyboardThemeSettings_RESOURCE_DIRS = plist

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"

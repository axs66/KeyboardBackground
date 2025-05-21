ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0

# 主 tweak
TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm Settings/ThemeManager.m
KeyboardTheme_CFLAGS = -fobjc-arc
KeyboardTheme_FRAMEWORKS = UIKit Foundation
KeyboardTheme_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

# 设置 Bundle
BUNDLE_NAME = KeyboardThemePrefs
KeyboardThemePrefs_FILES = Settings/KBTRootListController.m
KeyboardThemePrefs_CFLAGS = -fobjc-arc
KeyboardThemePrefs_FRAMEWORKS = UIKit Foundation
KeyboardThemePrefs_PRIVATE_FRAMEWORKS = Preferences
KeyboardThemePrefs_LIBRARIES = CepheiPrefs
KeyboardThemePrefs_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

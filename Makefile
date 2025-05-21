ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

# 主 tweak
TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm Settings/ThemeManager.m
KeyboardTheme_CFLAGS = -fobjc-arc
KeyboardTheme_FRAMEWORKS = UIKit Foundation
KeyboardTheme_PRIVATE_FRAMEWORKS =  # 不再引用 Preferences
KeyboardTheme_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

# 设置 Bundle
BUNDLE_NAME = KeyboardThemePrefs
KeyboardThemePrefs_FILES = Settings/KBTRootListController.m Settings/ThemeManager.m
KeyboardThemePrefs_CFLAGS = -fobjc-arc
KeyboardThemePrefs_FRAMEWORKS = UIKit Foundation Preferences
KeyboardThemePrefs_INSTALL_PATH = /Library/PreferenceBundles/KeyboardThemePrefs.bundle

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

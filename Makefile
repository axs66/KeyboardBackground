ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0

THEOS_PACKAGE_SCHEME = rootless

# 主 tweak
TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm Settings/ThemeManager.m
KeyboardTheme_CFLAGS = -fobjc-arc
KeyboardTheme_FRAMEWORKS = UIKit Foundation
KeyboardTheme_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

# 设置 Bundle
BUNDLE_NAME = KeyboardThemePrefs
KeyboardThemePrefs_FILES = Settings/KBTRootListController.m Settings/ThemeManager.m
KeyboardThemePrefs_CFLAGS = -fobjc-arc -I$(THEOS_PROJECT_DIR)/Cephei/Headers
KeyboardThemePrefs_FRAMEWORKS = UIKit Foundation
KeyboardThemePrefs_LIBRARIES = cephei

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"

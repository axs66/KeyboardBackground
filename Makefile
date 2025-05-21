ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0

# 主 tweak
TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm Settings/ThemeManager.m
KeyboardTheme_CFLAGS = -fobjc-arc
KeyboardTheme_FRAMEWORKS = UIKit Foundation
KeyboardTheme_PRIVATE_FRAMEWORKS =  # 不引用私有 Preferences
KeyboardTheme_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

# 设置 Bundle
BUNDLE_NAME = KeyboardThemePrefs
KeyboardThemePrefs_FILES = Settings/KBTRootListController.m Settings/ThemeManager.m
KeyboardThemePrefs_CFLAGS = -fobjc-arc -I$(THEOS_PROJECT_DIR)/Cephei/Headers
KeyboardThemePrefs_FRAMEWORKS = UIKit Foundation
KeyboardThemePrefs_LDFLAGS += -L$(THEOS_PROJECT_DIR)/Cephei/lib
KeyboardThemePrefs_LIBRARIES = CepheiSpringBoard
KeyboardThemePrefs_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS)/makefiles/common.mk

# 这里使用bundle.mk构建设置界面Bundle
include $(THEOS_MAKE_PATH)/bundle.mk
# 这里使用tweak.mk构建主tweak
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

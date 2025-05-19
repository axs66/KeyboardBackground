TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm
KeyboardTheme_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

# 设置界面只安装 plist，不编译任何 .m 文件
BUNDLE_NAME = KeyboardThemeSettings
KeyboardThemeSettings_INSTALL_PATH = /Library/PreferenceBundles
KeyboardThemeSettings_RESOURCE_DIRS = layout/Library/PreferenceLoader/Preferences
include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"

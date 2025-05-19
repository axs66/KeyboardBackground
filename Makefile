TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_PACKAGE_SCHEME = rootless  # Dopamine越狱保留，否则删除

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm
KeyboardTheme_FRAMEWORKS = UIKit

# 指定filter plist，告诉Theos哪些进程注入tweak
KeyboardTheme_FILTERS = plist/KeyboardTheme.plist

include $(THEOS_MAKE_PATH)/tweak.mk

# 安装纯plist偏好设置文件到系统设置界面（不编译bundle）
KeyboardTheme_INSTALL_PATH = /Library/PreferenceLoader/Preferences
KeyboardTheme_EXTRA_INSTALL_FILES = layout/Library/PreferenceLoader/Preferences/KeyboardTheme.plist

after-install::
	install.exec "killall -9 SpringBoard"

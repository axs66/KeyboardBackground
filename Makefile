ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_PACKAGE_SCHEME = rootless  # 适用于Dopamine等rootless越狱

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm
KeyboardTheme_FRAMEWORKS = UIKit
KeyboardTheme_CFLAGS = -fobjc-arc

# 指定过滤器文件路径（现在在根目录）
KeyboardTheme_FILTER = KeyboardTheme.plist

# 额外安装文件（设置界面和资源图片）
KeyboardTheme_EXTRA_INSTALL_FILES += \
    KeyboardTheme.plist \
    Resources/keyboard_bg.png \
    layout/Library/PreferenceLoader/Preferences/KeyboardTheme.plist

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

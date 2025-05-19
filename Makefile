ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_PACKAGE_SCHEME = rootless  # 适用于Dopamine等rootless越狱

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm
KeyboardTheme_FRAMEWORKS = UIKit
KeyboardTheme_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

# 额外安装文件（设置界面和资源图片）
KeyboardTheme_EXTRA_INSTALL_FILES += \
    Resources/keyboard_bg.png \
    layout/Library/PreferenceLoader/Preferences/KeyboardTheme.plist

after-install::
	install.exec "killall -9 SpringBoard"

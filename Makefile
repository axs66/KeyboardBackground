ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_PACKAGE_SCHEME = rootless  # 适用于Dopamine等rootless越狱

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm
KeyboardTheme_FRAMEWORKS = UIKit
KeyboardTheme_CFLAGS = -fobjc-arc

# 过滤器plist路径（确保文件存在）
KeyboardTheme_FILTERS = plist/KeyboardTheme.plist

include $(THEOS_MAKE_PATH)/tweak.mk

# 额外安装文件
KeyboardTheme_EXTRA_INSTALL_FILES += \
    Resources/keyboard_bg.png \
    PreferenceLoader/Preferences/KeyboardTheme.plist

after-install::
	install.exec "killall -9 SpringBoard"

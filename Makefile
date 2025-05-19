TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_PACKAGE_SCHEME = rootless  # 如果你是 Dopamine 越狱，保留这行；否则可删除

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm
KeyboardTheme_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

# 安装 Preferences plist 文件到系统设置界面
# 注意：这是 "纯 plist 设置" 模式，没有 .m/.bundle 控制器
KeyboardTheme_EXTRA_INSTALL_FILES = \
    layout/Library/PreferenceLoader/Preferences/KeyboardTheme.plist

after-install::
	install.exec "killall -9 SpringBoard"

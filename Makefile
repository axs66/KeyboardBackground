ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:16.0

include $(THEOS)/makefiles/common.mk

PACKAGE_VERSION = 1.0.0
TARGET_CODESIGN = ldid
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = KeyboardTheme
KeyboardTheme_FILES = Tweak.xm Settings/KBTRootListController.m
KeyboardTheme_FRAMEWORKS = UIKit CoreGraphics
# KeyboardTheme_PRIVATE_FRAMEWORKS = AppSupport  # 注释掉此行

include $(THEOS_MAKE_PATH)/tweak.mk

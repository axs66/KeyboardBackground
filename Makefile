ARCHS = arm64e arm64
TARGET = iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardBackground

KeyboardBackground_FILES = Tweak.xm
KeyboardBackground_CFLAGS = -fobjc-arc -framework Foundation -framework UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

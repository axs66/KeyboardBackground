export TARGET = iphone:clang:16.0:14.0
export ARCHS = arm64 arm64e
export THEOS = $(shell echo $THEOS)

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwipeInputTweak

SwipeInputTweak_FILES = Tweak.xm
SwipeInputTweak_CFLAGS = -fobjc-arc
SwipeInputTweak_FRAMEWORKS = UIKit Foundation
SwipeInputTweak_EXTRA_FRAMEWORKS = ElleKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"

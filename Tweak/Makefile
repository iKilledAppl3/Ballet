ARCHS = arm64
TARGET = appletv:clang::13.4

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Ballet
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation AVFoundation

include $(THEOS_MAKE_PATH)/tweak.mk

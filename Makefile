export THEOS_DEVICE_IP = 127.0.0.1
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = bypasssvvnv8
bypasssvvnv8_FILES = Tweak.x
bypasssvvnv8_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

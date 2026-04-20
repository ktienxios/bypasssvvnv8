TWEAK_NAME = GoogleService
GoogleService_FILES = Tweak.mm
GoogleService_LIBRARIES = substrate
GoogleService_CFLAGS = -fobjc-arc -I$(THEOS)/include
GoogleService_LDFLAGS = -L$(THEOS)/lib -lsubstrate

ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.5

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

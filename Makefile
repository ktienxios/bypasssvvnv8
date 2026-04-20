# Tên Project
TWEAK_NAME = GoogleService

# File xử lý chính
GoogleService_FILES = Tweak.x

# Frameworks và Thư viện
GoogleService_FRAMEWORKS = UIKit Foundation
GoogleService_LIBRARIES = substrate

# Cờ biên dịch cho iOS cao (iOS 14.0 trở lên)
# -fobjc-arc: Quản lý bộ nhớ
# -fvisibility=hidden: Giấu tên hàm (Tàng hình)
GoogleService_CFLAGS = -fobjc-arc -fvisibility=hidden -O3

# Gọt sạch thông tin nhị phân giúp giảm dung lượng và tàng hình
GoogleService_LDFLAGS = -s

# Kiến trúc Arm64 cho iPhone đời mới (máy zin iOS cao)
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

# Đường dẫn Theos trên Codespaces (mặc định nếu bạn cài theo script)
THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

# Dọn dẹp sau khi build
clean::
	rm -rf ./obj/*
	rm -rf ./.theos/*

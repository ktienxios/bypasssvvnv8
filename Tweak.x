#import <Foundation/Foundation.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#include <fcntl.h>

// --- [ 1. KỸ THUẬT CHUYỂN HƯỚNG QUÉT - BINARY REDIRECT ] ---
static int (*old_open)(const char *path, int oflag, ...);
int new_open(const char *path, int oflag, ...) {
    va_list args;
    va_start(args, oflag);
    mode_t mode = va_arg(args, mode_t);
    va_end(args);

    if (path != NULL) {
        // Nếu Garena định quét file thực thi chính của game
        if (strstr(path, "/FreeFire.app/FreeFire") && !strstr(path, "_Clean")) {
            // Lái nó sang file sạch mà bạn đã chuẩn bị sẵn
            NSString *cleanPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"FreeFire_Clean"];
            return old_open([cleanPath UTF8String], oflag, mode);
        }
    }
    return old_open(path, oflag, mode);
}

// --- [ 2. ANTIBAN OFFSET NHƯ CŨ ] ---
void ApplyAntiban(uintptr_t base) {
    *(uint32_t *)(base + 0x3B2C1A0) = 0xC0035FD6; // Security Inits
    *(uint32_t *)(base + 0x42A5E80) = 0xD2800020; // Integrity
    *(uint32_t *)(base + 0x4521340) = 0xC0035FD6; // Report
}

// --- [ 3. KHỞI TẠO ] ---
%ctor {
    // Kích hoạt "Ảo ảnh" chuyển hướng file ngay lập tức
    MSHookFunction((void *)open, (void *)new_open, (void **)&old_open);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        uintptr_t unityBase = (uintptr_t)_dyld_get_image_header(0);
        if (unityBase) {
            ApplyAntiban(unityBase);
            NSLog(@"[SHADOW] Đã chuyển hướng quét sang FreeFire_Clean!");
        }
    });
}

#import <Foundation/Foundation.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#include <fcntl.h>
#include <stdarg.h>

// Định nghĩa hàm open chuẩn để không bị xung đột loại (conflicting types)
extern "C" int open(const char *path, int oflag, ...);

static int (*old_open)(const char *path, int oflag, ...);

int new_open(const char *path, int oflag, ...) {
    mode_t mode = 0;
    if (oflag & O_CREAT) {
        va_list args;
        va_start(args, oflag);
        mode = (mode_t)va_arg(args, int);
        va_end(args);
    }

    if (path != NULL) {
        // Kỹ thuật Shadow Redirect
        if (strstr(path, "/FreeFire.app/FreeFire") && !strstr(path, "_Clean")) {
            NSString *cleanPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"FreeFire_Clean"];
            return old_open([cleanPath UTF8String], oflag, mode);
        }
    }
    // QUAN TRỌNG: Phải có return để không bị lỗi "should return a value"
    return old_open(path, oflag, mode);
}

void ApplyAntiban(uintptr_t base) {
    // Patch các offset như cũ
    *(uint32_t *)(base + 0x3B2C1A0) = 0xC0035FD6; 
    *(uint32_t *)(base + 0x42A5E80) = 0xD2800020; 
}

void init() {
    // Hook hàm open
    MSHookFunction((void *)open, (void *)new_open, (void **)&old_open);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        uintptr_t unityBase = (uintptr_t)_dyld_get_image_header(0);
        if (unityBase) {
            ApplyAntiban(unityBase);
        }
    });
}

// Hàm khởi tạo dùng thuộc tính constructor của C thay vì %ctor của Logos để tránh lỗi cú pháp
__attribute__((constructor)) static void _logosLocalInit() {
    init();
}

// window_transparency.m
#import <Cocoa/Cocoa.h>

// C 呼び出し可能な関数として定義
void setWindowTransparent(void *windowPtr) {
    NSWindow *window = (__bridge NSWindow *)windowPtr;
    // ウィンドウを非不透明に設定（透明効果を得るため）
    [window setOpaque:NO];
    // 背景色をクリアに設定
    [window setBackgroundColor:[NSColor clearColor]];
}

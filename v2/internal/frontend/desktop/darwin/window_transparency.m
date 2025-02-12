// window_transparency.m
#import <Cocoa/Cocoa.h>

void setWindowTransparent(void *windowPtr) {
    NSWindow *window = (__bridge NSWindow *)windowPtr;
    
    // 呼び出し時のデバッグログ出力
    NSLog(@"[DEBUG] setWindowTransparent called. Window: %@", window);
    
    // ウィンドウを非不透明に設定（透明にするため）
    [window setOpaque:NO];
    // 背景色をクリアに設定
    [window setBackgroundColor:[NSColor clearColor]];
    
    // 変更後の状態をログ出力（opaque プロパティの値を確認）
    NSLog(@"[DEBUG] After transparency update, isOpaque: %d", [window isOpaque]);
}

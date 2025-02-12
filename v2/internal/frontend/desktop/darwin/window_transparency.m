// window_transparency.m
#import <Cocoa/Cocoa.h>

void writeLog(NSString *message) {
    // ログを書き込むファイルのパスを指定
    NSString *logPath = @"/tmp/wails_debug.log";
    
    // ファイルが存在しなければ作成
    if (![[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
        [[NSFileManager defaultManager] createFileAtPath:logPath contents:nil attributes:nil];
    }
    
    // ファイルハンドルを取得
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
    if (fileHandle) {
        [fileHandle seekToEndOfFile];
        NSString *logMessage = [NSString stringWithFormat:@"%@\n", message];
        [fileHandle writeData:[logMessage dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
}

// window_transparency.m
void setWindowTransparent(void *windowPtr) {
    NSWindow *window = (__bridge NSWindow *)windowPtr;
    
    writeLog([NSString stringWithFormat:@"[DEBUG] setWindowTransparent called. Window: %@", window]);
    
    // 基本的な透過設定
    [window setOpaque:NO];
    [window setBackgroundColor:[NSColor clearColor]];
    [window setAlphaValue:1.0];
    [window setHasShadow:NO];
    
    // Visual Effect Viewの設定
    NSView *contentView = [window contentView];
    NSVisualEffectView *visualEffectView = [[NSVisualEffectView alloc] initWithFrame:[contentView bounds]];
    [visualEffectView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [visualEffectView setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
    [visualEffectView setState:NSVisualEffectStateActive];
    
    // macOS バージョンに応じた設定
    if (@available(macOS 10.14, *)) {
        [visualEffectView setMaterial:NSVisualEffectMaterialUnderWindowBackground];
    } else {
        // 10.13以前用の設定
        [visualEffectView setMaterial:NSVisualEffectMaterialLight];
    }
    
    [contentView addSubview:visualEffectView positioned:NSWindowBelow relativeTo:nil];
    
    // WebViewの背景も透明に
    NSArray *subviews = [contentView subviews];
    for (NSView *view in subviews) {
        if ([view isKindOfClass:[WKWebView class]]) {
            WKWebView *webView = (WKWebView *)view;
            [webView setValue:@NO forKey:@"drawsBackground"];
            [[webView configuration].preferences setValue:@YES forKey:@"transparentBackground"];
            break;
        }
    }
    
    writeLog([NSString stringWithFormat:@"[DEBUG] After transparency update, isOpaque: %d", [window isOpaque]]);
    writeLog([NSString stringWithFormat:@"[DEBUG] Window alpha value: %f", [window alphaValue]]);
}
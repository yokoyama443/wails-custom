// window_transparency.m
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "window_transparency.h"

void writeLog(NSString *message) {
    NSString *logPath = @"/tmp/wails_debug.log";
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
        [[NSFileManager defaultManager] createFileAtPath:logPath contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
    if (fileHandle) {
        [fileHandle seekToEndOfFile];
        NSString *logMessage = [NSString stringWithFormat:@"%@\n", message];
        [fileHandle writeData:[logMessage dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
}

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
    
    if (@available(macOS 10.14, *)) {
        [visualEffectView setMaterial:NSVisualEffectMaterialUnderWindowBackground];
    } else {
        [visualEffectView setMaterial:NSVisualEffectMaterialLight];
    }
    
    [contentView addSubview:visualEffectView positioned:NSWindowBelow relativeTo:nil];
    
    // WebViewの背景も透明に
    for (NSView *view in [contentView subviews]) {
        if ([view isKindOfClass:[WKWebView class]]) {
            WKWebView *webView = (WKWebView *)view;
            [webView setValue:@NO forKey:@"drawsBackground"];
            
            // プリファレンスの設定
            WKPreferences *prefs = webView.configuration.preferences;
            if ([prefs respondsToSelector:@selector(setValue:forKey:)]) {
                [prefs setValue:@YES forKey:@"transparentBackground"];
            }
            break;
        }
    }
    
    writeLog([NSString stringWithFormat:@"[DEBUG] After transparency update, isOpaque: %d", [window isOpaque]]);
    writeLog([NSString stringWithFormat:@"[DEBUG] Window alpha value: %f", [window alphaValue]]);
}
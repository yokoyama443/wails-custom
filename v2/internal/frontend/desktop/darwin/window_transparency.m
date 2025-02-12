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

void setWindowTransparent(void *windowPtr) {
    NSWindow *window = (__bridge NSWindow *)windowPtr;
    
    // ログ出力
    writeLog([NSString stringWithFormat:@"[DEBUG] setWindowTransparent called. Window: %@", window]);
    
    [window setOpaque:NO];
    [window setBackgroundColor:[NSColor clearColor]];
    
    writeLog([NSString stringWithFormat:@"[DEBUG] After transparency update, isOpaque: %d", [window isOpaque]]);
}

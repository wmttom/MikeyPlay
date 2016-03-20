//
//  AppDelegate.h
//  MiKeyPlay
//
//  Created by tom on 16/3/19.
//  Copyright © 2016年 tom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>


@interface AppDelegate : NSObject <NSApplicationDelegate,NSWindowDelegate>

@property (nonatomic, strong) NSStatusItem* statusItem;
@property  BOOL stopItnuesStatus;
@property (nonatomic, strong) NSThread *stopItunesThread;

@end

@interface NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;
@end
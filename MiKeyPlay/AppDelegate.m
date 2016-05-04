//
//  AppDelegate.h
//  MiKeyPlay
//
//  Created by tom on 16/3/19.
//  Copyright © 2016年 tom. All rights reserved.
//

#import "AppDelegate.h"
#import "IOKit/hid/IOHIDManager.h"
#import "PRLHotKeyKit.h"


@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *aboutWindow;
@property (weak) IBOutlet NSWindow *hotkeyWindow;
@property (weak) IBOutlet NSTextField *hotkeyTextField1;
@property (weak) IBOutlet NSTextField *hotkeyTextField2;
@property (weak) IBOutlet NSTextField *hotkeyTextField3;
@property (weak) IBOutlet NSImageView *AppIconImageView;
@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet NSTextField *emailTextField;

@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.stopItnuesStatus = false;
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSImage *image = [NSImage imageNamed:@"desktop"];
    [image setTemplate:YES];
    [_statusItem setImage:image];
    [_statusItem setHighlightMode:YES];
    [_statusItem setTarget:self];
    
    [self initMenu];
    [self initHid];
    [self initAboutWindow];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)initAboutWindow {
    self.AppIconImageView.image = [NSApp applicationIconImage];
    [self.urlTextField setAllowsEditingTextAttributes: YES];
    [self.urlTextField setSelectable: YES];
    [self.emailTextField setAllowsEditingTextAttributes: YES];
    [self.emailTextField setSelectable: YES];
    NSURL* email = [NSURL URLWithString:@"mailto:wmttom@gmail.com"];
    NSURL* url = [NSURL URLWithString:@"https://github.com/wmttom/MikeyPlay"];
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString: [NSAttributedString hyperlinkFromString:@"https://github.com/wmttom/MikeyPlay" withURL:url]];
    NSMutableAttributedString* emailStr = [[NSMutableAttributedString alloc] init];
    [emailStr appendAttributedString: [NSAttributedString hyperlinkFromString:@"wmttom@gmail.com" withURL:email]];
    [self.urlTextField setAttributedStringValue: string];
    [self.emailTextField setAttributedStringValue: emailStr];
}

- (void)terminate:(id)sender {
    [self terminate:nil];
}

- (void)runStopItunes:(id)sender {
    // NSLog(@"runStopItunes");
    NSMenuItem *menuItem = [self.statusItem.menu itemAtIndex:0];
    if (self.stopItnuesStatus) {
        [self StopStopItunesThread];
        self.stopItnuesStatus = false;
        menuItem.state = NSOffState;
    } else {
        [self runStopItunesThread];
        self.stopItnuesStatus = true;
        menuItem.state = NSOnState;
    }
}

- (void)windowDidBecomeMain:(NSNotification *)notification {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    for (int i=1; i<4; i++) {
        NSString *keyName = [NSString stringWithFormat:@"centerButton%@", [NSNumber numberWithInt:i]];
        NSArray *centerButton = [userDefaultes arrayForKey:keyName];
        PRLHotKey *hotkeyObj =[[PRLHotKey alloc]initWithKeyCode:[[centerButton objectAtIndex:0] integerValue] modifiers:[[centerButton objectAtIndex:1]integerValue]];
        switch (i) {
            case 1:
                self.hotkeyTextField1.objectValue = hotkeyObj;
                break;
            case 2:
                self.hotkeyTextField2.objectValue = hotkeyObj;
                break;
            case 3:
                self.hotkeyTextField3.objectValue = hotkeyObj;
                break;
        }
    }
}


- (void)initMenu {
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    [menu addItemWithTitle:NSLocalizedString(@"Stop iTunes",nil) action:@selector(runStopItunes:) keyEquivalent:@""];
    [menu addItemWithTitle:NSLocalizedString(@"Set Hotkey",nil) action:@selector(setHotkey:) keyEquivalent:@""];
    [menu addItemWithTitle:NSLocalizedString(@"About",nil) action:@selector(about:) keyEquivalent:@""];
    [menu addItemWithTitle:NSLocalizedString(@"Quit",nil) action:@selector(terminate:) keyEquivalent:@""];
    NSMenuItem *menuItem = [menu itemAtIndex:0];
    menuItem.state = NSOffState;
    self.statusItem.menu = menu;
    
}

- (void) about:(id)sender {
    [self.aboutWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void) setHotkey:(id)sender {
    [self.hotkeyWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)initHid {
    IOHIDManagerRef HIDManager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    CFMutableDictionaryRef matchDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(matchDict, CFSTR( kIOHIDDeviceUsagePageKey ), CFBridgingRetain([NSNumber numberWithInt:12]));
    CFDictionarySetValue(matchDict, CFSTR( kIOHIDDeviceUsageKey ), CFBridgingRetain([NSNumber numberWithInt:1]));
    CFDictionarySetValue(matchDict, CFSTR(kIOHIDProductKey), CFSTR("Apple Mikey HID Driver"));
    IOHIDManagerSetDeviceMatching(HIDManager, matchDict);
    //    IOHIDManagerRegisterDeviceMatchingCallback(HIDManager, &Handle_DeviceMatchingCallback, NULL);
    //    IOHIDManagerRegisterDeviceRemovalCallback(HIDManager, &Handle_DeviceRemovalCallback, NULL);
    IOHIDManagerRegisterInputValueCallback(HIDManager, &Handle_IOHIDInputValueCallback, NULL );
    IOHIDManagerScheduleWithRunLoop(HIDManager, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    IOReturn IOReturn = IOHIDManagerOpen(HIDManager, kIOHIDOptionsTypeNone);
    if(IOReturn) NSLog(@"IOHIDManagerOpen failed.");
}

+ (void)simulateHotkeyWithIndex:(NSUInteger)index {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *keyName = [NSString stringWithFormat:@"centerButton%lu",(unsigned long)index];
    NSArray *centerButton = [userDefaultes arrayForKey:keyName];
    NSUInteger keyCode = [[centerButton objectAtIndex:0] integerValue];
    NSUInteger modifiers = [[centerButton objectAtIndex:1] integerValue];
    CGEventRef keyDown = CGEventCreateKeyboardEvent(NULL, keyCode, true);
    CGEventRef keyUp = CGEventCreateKeyboardEvent(NULL, keyCode, false);
    //        CGEventSetFlags(keyDown, kCGEventFlagMaskCommand ^ kCGEventFlagMaskAlternate ^ kCGEventFlagMaskShift);
    //        CGEventSetFlags(keyUp, kCGEventFlagMaskCommand ^ kCGEventFlagMaskAlternate  ^ kCGEventFlagMaskShift);
    CGEventSetFlags(keyDown, modifiers);
    CGEventSetFlags(keyUp, modifiers);
    CGEventPost(kCGHIDEventTap, keyDown);
    CGEventPost(kCGHIDEventTap, keyUp);
}

static void Handle_IOHIDInputValueCallback(
                                           void *          inContext,
                                           IOReturn        inResult,
                                           void *          inSender,
                                           IOHIDValueRef   inIOHIDValueRef
                                           ) {
    IOHIDElementRef elem = IOHIDValueGetElement(inIOHIDValueRef);
    uint32_t scancode = IOHIDElementGetUsage(elem);
    //    if (scancode < 0x80 || scancode > 0x8D) {
    //        return;
    //    }
    
    BOOL pressed = IOHIDValueGetIntegerValue(inIOHIDValueRef);
    if(scancode==kHIDUsage_GD_SystemMenuDown) {
        // NSLog(@"MenuDown");
    }
    else if(scancode == kHIDUsage_GD_SystemMenuUp) {
        // NSLog(@"MenuUp");
    }
    else if(scancode == kHIDUsage_GD_SystemMenuSelect && pressed == true) {
        // NSLog(@"MenuSelect");
        [AppDelegate simulateHotkeyWithIndex: 1];
    }
    else if(scancode == kHIDUsage_GD_SystemMenuRight && pressed == true) {
        // NSLog(@"MenuSelect2");
        [AppDelegate simulateHotkeyWithIndex: 2];
    }
    else if(scancode == kHIDUsage_GD_SystemMenuLeft  && pressed == true) {
        // NSLog(@"MenuSelect3");
        [AppDelegate simulateHotkeyWithIndex: 3];
    }
    
}


//static void Handle_DeviceMatchingCallback(void *inContext,
//                                          IOReturn inResult,
//                                          void *inSender,
//                                          IOHIDDeviceRef inIOHIDDeviceRef)
//{
//    NSString *devName = [NSString stringWithUTF8String:CFStringGetCStringPtr(IOHIDDeviceGetProperty(inIOHIDDeviceRef, CFSTR("Product")), kCFStringEncodingMacRoman)];
//    if ([devName isEqualToString:@"Apple Mikey HID Driver"]) {
//        // NSLog(@"device added: %p\nModel: %@\n",
//              inIOHIDDeviceRef,
//              devName);
//    }
//}

//static void Handle_DeviceRemovalCallback(void *inContext,
//                                         IOReturn inResult,
//                                         void *inSender,
//                                         IOHIDDeviceRef inIOHIDDeviceRef)
//{
//    @try {
//        NSString *devName = [NSString stringWithUTF8String:CFStringGetCStringPtr(IOHIDDeviceGetProperty(inIOHIDDeviceRef, CFSTR("Product")), kCFStringEncodingMacRoman)];
//        if ([devName isEqualToString:@"Apple Mikey HID Driver"]) {
//            // NSLog(@"device remove: %p\nModel: %@\n",
//                  inIOHIDDeviceRef,
//                  devName);
//        }
//    }
//    @catch (NSException *exception) {
//    };
//}


- (void)runStopItunesThread {
    // NSLog(@"runStopItunesThread");
    self.stopItunesThread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:nil];
    [self.stopItunesThread start];
    // NSLog(@"start %hhd", self.stopItunesThread.executing);
}

- (void)StopStopItunesThread {
    // NSLog(@"StopStopItunesThread");
    [self.stopItunesThread cancel];
    // NSLog(@"cancel %hhd", self.stopItunesThread.executing);
}

- (void)run:(id)sender {
    // NSLog(@"run");
    while (true) {
        if ([NSThread currentThread].isCancelled) {
            break;
        }
        sleep(0.05);
        system("ps -ef | grep iTunes | grep -v grep | awk '{print $2}' | xargs kill");
        //        NSArray *runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
        //        for (NSRunningApplication *app in runningApplications) {
        //            NSString *bundle = [app localizedName];
        //            if ([bundle isEqualToString:@"iTunes"]) {
        //                // NSLog(@"iTuens got it");
        //                system("killall iTunes");
        //            }
        //        }
    }
}

- (IBAction)hotkeyTextAction1:(id)sender {
    [self saveHotkey:(PRLHotKey *)[self.hotkeyTextField1 objectValue] index:1];
}

- (IBAction)hotkeyTextAction2:(id)sender {
    [self saveHotkey:(PRLHotKey *)[self.hotkeyTextField2 objectValue] index:2];
}

- (IBAction)hotkeyTextAction3:(id)sender {
    [self saveHotkey:(PRLHotKey *)[self.hotkeyTextField3 objectValue] index:3];
}

- (void)saveHotkey:(PRLHotKey *)hotKey index:(NSUInteger)index {
    if ((!hotKey) || hotKey.isEmpty)
        return;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *keyName = [NSString stringWithFormat:@"centerButton%lu",(unsigned long)index];
    [userDefaultes setObject:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:hotKey.keyCode], [NSNumber numberWithUnsignedInteger:hotKey.modifiers], nil] forKey:keyName];
    [userDefaultes synchronize];
}


@end

@implementation NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    //    [attrString addAttribute:
    //     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    [attrString endEditing];
    return attrString;
}
@end

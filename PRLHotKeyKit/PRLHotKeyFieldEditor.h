//
//  PRLHotKeyFieldEditor.h
//  PRLHotKey
//
//  Created by Kevin Hayes on 11-12-09.
//  Copyright (c) 2011 Parliant. All rights reserved.
//

#import <AppKit/AppKit.h>

/** The field editor used by PRLHotKeyFieldCell
 Unless you are subclassing NSTextField or NSTextFieldCell you will likely not need to use this directly.
 */
@interface PRLHotKeyFieldEditor : NSTextView

/** creates (if necessary) and initializes the shared field editor
 @returns the shared instance of PRLHotKeyFieldEditor
 Note, most dialog boxes and NSTableViews reuse the same field editor.
 */
+ (instancetype)sharedHotKeyView;
@end

//
//  PRLHotKeyFieldCell.h
//  PRLHotKey
//
//  Created by Parliant on 11/27/2013.
//
//

#import <Cocoa/Cocoa.h>

/** This class is used to replace the field cell in NSTextFields and in NSTableViews to facilitate display and entry of hotkeys in text fields and table cells.
 */
@interface PRLHotKeyFieldCell : NSTextFieldCell <NSTextViewDelegate,NSCoding,NSCopying>
@end

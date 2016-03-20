//
//  PRLHotKey
//  PRLHotKey
//
//  Created by Kevin Hayes at Parliant on 12/4/2013.
//
//

#import <Cocoa/Cocoa.h>

/** PRLHotKey is the model class for PRLHotKeyKit. It stores the data required to generate a hotkey
 */
@interface PRLHotKey : NSObject <NSCopying, NSCoding>

/** keyboard modifiers (command, shift, option, control, fn) for the hotkey
 */
@property (nonatomic,readonly) NSUInteger modifiers;

/** the keyboard code for the hotkey (not the ASCII code for the keyboard character
 */
@property (nonatomic,readonly) NSUInteger keyCode;

/** a printable string for the hotkey, suitable for a text field or documentation
 */
@property (nonatomic,readonly) NSString *displayString;

/** a hotkey instance but a non-functioning hotkey, similar to an empty string
 both modifier and keycode have a value of 0
 */
@property (nonatomic,readonly,getter=isEmpty) BOOL empty;


/** given a string return an instance of PRLHotKey
 @param hotKeyString a string representing the hotkey (modifiers,space,character, e.g. @"⌘⇧ K"
 @returns an instance of PRLHotKey based on the given string or nil on invalid strings.
 @warning this method is used by the PRLHotKeyFieldCell to convert the string value to object value and vice versa. An equivalent hotkey must be created from the modifier and key codes before it can be converted from string. If such an instance was not created, the method returns nil.
 */
+ (PRLHotKey *)hotKeyForString:(NSString *)hotKeyString;

/** generates an NSString based on the given key code and modifier codes
 @param keyCode the keyboard code for the character. Note, this is not the ASCII code
 @param modifiers the modifier codes for the hot key
 @returns an NSString based on the hotkey data
 */
+ (NSString *)stringForKeyCode:(NSUInteger)keyCode modifiers:(NSUInteger)modifiers;

/** generates a string representation of the receiver
 @returns an NSString containing the hotkey
 */
- (NSString *)stringRepresentation;

/** creates and inititalizes an instance of PRLHotKey based on the provided keyCode on modifiers
 @param keyCode the keyboard code for the character in the hotkey
 @param modifiers the modifier code for the modifiers pressed to enter the hotkey
 @returns an instance of PRLHotKey based on the provided paramaters
 */
- (id)initWithKeyCode:(NSUInteger)keyCode modifiers:(NSUInteger)modifiers;

/** the key equivalent string for setting key equivalent on NSMenu
 @returns an NSString containing only the character of the receiver
 This method is used for providing an NSMenu instance with the key equivalent. NSMenu can not accept string like "F1" or "Clear" but require the single character equivalent. This method provides that.
 */
- (NSString *)keyEquivalentStringForMenuForHotKey;

@end

	//
//  PRLHotKey
//  PRLHotKey
//
//  Created by Parliant on 12/4/2013.
//
//

#import "PRLHotKey.h"
#import <Carbon/Carbon.h>

NSMutableDictionary *_keyCodeLookupDictionary;
NSDictionary *_fallbackKeyCodeDictionary;

@implementation PRLHotKey
+ (void)initialize
{
	_keyCodeLookupDictionary = [[NSMutableDictionary alloc] init];
	_fallbackKeyCodeDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
								  @"a", @"0",
								  @"s", @"1",
								  @"d", @"2",
								  @"f", @"3",
								  @"h", @"4",
								  @"g", @"5",
								  @"z", @"6",
								  @"x", @"7",
								  @"c", @"8",
								  @"v", @"9",
								  @"§", @"10",
								  @"b", @"11",
								  @"q", @"12",
								  @"w", @"13",
								  @"e", @"14",
								  @"r", @"15",
								  @"y", @"16",
								  @"t", @"17",
								  @"1", @"18",
								  @"2", @"19",
								  @"3", @"20",
								  @"4", @"21",
								  @"6", @"22",
								  @"5", @"23",
								  @"=", @"24",
								  @"9", @"25",
								  @"7", @"26",
								  @"-", @"27",
								  @"8", @"28",
								  @"0", @"29",
								  @"]", @"30",
								  @"o", @"31",
								  @"u", @"32",
								  @"[", @"33",
								  @"i", @"34",
								  @"p", @"35",
								  @"⏎", @"36",
								  @"l", @"37",
								  @"j", @"38",
								  @"'", @"39",
								  @"k", @"40",
								  @";", @"41",
								  @"\\", @"42",
								  @",", @"43",
								  @"/", @"44",
								  @"n", @"45",
								  @"m", @"46",
								  @".", @"47",
								  @"⇥", @"48",
								  @" ", @"49",
								  @"`", @"50",
								  @"⃪", @"51",
								  @"␃", @"52",
								  @"⎋", @"53",
								  @" ", @"64",
								  @".", @"65",
								  @" ", @"66",
								  @"*", @"67",
								  @"+", @"69",
								  @" ", @"70",
								  @"⎋", @"71",
								  @" ", @"72",
								  @"/", @"75",
								  @" ", @"76",
								  @" ", @"77",
								  @"-", @"78",
								  @" ", @"79",
								  @" ", @"80",
								  @"=", @"81",
								  @"0", @"82",
								  @"1", @"83",
								  @"2", @"84",
								  @"3", @"85",
								  @"4", @"86",
								  @"5", @"87",
								  @"6", @"88",
								  @"7", @"89",
								  @"8", @"91",
								  @"9", @"92",
								  @" ", @"114",
								  @" ", @"115",
								  @" ;", @"116",
								  @"⌫", @"117",
								  @" ", @"118",
								  @" ", @"119",
								  @" ", @"120",
								  @" ", @"121",
								  @" ", @"122",
								  @" ", @"123",
								  @" ", @"124",
								  @" ", @"125",
								  @" ", @"126",
								  @"¥", @"93",
								  @"_", @"94",
								  @",", @"95",
								  nil];
}

+ (PRLHotKey *)hotKeyForString:(NSString *)hotKeyString
{
	NSArray *components = [hotKeyString componentsSeparatedByString:@" "];
	NSString *keyString;
	NSString *modifierString;
	NSUInteger modifiers = 0;
	NSUInteger keyCode = 0;

	if ([components count] < 2)
	{
		keyString = hotKeyString;
	}
	else
	{
		modifierString = components[0];
		keyString = components[1];
		if (!([modifierString rangeOfString:@"⌃"].location == NSNotFound))
			modifiers |= NSControlKeyMask;
		if (!([modifierString rangeOfString:@"⇧"].location == NSNotFound))
			modifiers |= NSShiftKeyMask;
		if (!([modifierString rangeOfString:@"⌥"].location == NSNotFound))
			modifiers |= NSAlternateKeyMask;
		if (!([modifierString rangeOfString:@"⌘"].location == NSNotFound))
			modifiers |= NSCommandKeyMask;
		if (!([modifierString rangeOfString:@"fn"].location == NSNotFound))
			modifiers |= NSFunctionKeyMask;
	}
	if ([keyString length])
	{
		NSNumber *keyNumber = [_keyCodeLookupDictionary objectForKey:keyString];
		if (!keyNumber)
		{
			return nil;
		}
		keyCode = [keyNumber unsignedIntegerValue];
	}
	return [[PRLHotKey alloc] initWithKeyCode:keyCode modifiers:modifiers];
}

+ (NSString *)keyEquivalentStringForMenuForKeyCode:(NSUInteger)keyCode modifiers:(NSUInteger)modifiers
{
	unichar myChar = 0;

	if (modifiers == 0 && keyCode == 0)
		return @"";

	switch (keyCode)
	{
		case kVK_ANSI_KeypadClear:
			myChar = NSClearDisplayFunctionKey;
			break;
		case kVK_UpArrow:
			myChar = NSUpArrowFunctionKey;
			break;
		case kVK_DownArrow:
			myChar = NSDownArrowFunctionKey;
			break;
		case kVK_LeftArrow:
			myChar = NSLeftArrowFunctionKey;
			break;
		case kVK_RightArrow:
			myChar = NSRightArrowFunctionKey;
			break;
		case kVK_F1:
			myChar = NSF1FunctionKey;
			break;
		case kVK_F2:
			myChar = NSF2FunctionKey;
			break;
		case kVK_F3:
			myChar = NSF3FunctionKey;
			break;
		case kVK_F4:
			myChar = NSF4FunctionKey;
			break;
		case kVK_F5:
			myChar = NSF5FunctionKey;
			break;
		case kVK_F6:
			myChar = NSF6FunctionKey;
			break;
		case kVK_F7:
			myChar = NSF7FunctionKey;
			break;
		case kVK_F8:
			myChar = NSF8FunctionKey;
			break;
		case kVK_F9:
			myChar = NSF9FunctionKey;
			break;
		case kVK_F10:
			myChar = NSF10FunctionKey;
			break;
		case kVK_F11:
			myChar = NSF11FunctionKey;
			break;
		case kVK_F12:
			myChar = NSF12FunctionKey;
			break;
		case kVK_F13:
			myChar = NSF13FunctionKey;
			break;
		case kVK_F14:
			myChar = NSF14FunctionKey;
			break;
		case kVK_F15:
			myChar = NSF15FunctionKey;
			break;
		case kVK_F16:
			myChar = NSF16FunctionKey;
			break;
		case kVK_F17:
			myChar = NSF17FunctionKey;
			break;
		case kVK_F18:
			myChar = NSF18FunctionKey;
			break;
		case kVK_F19:
			myChar = NSF19FunctionKey;
			break;
		case kVK_F20:
			myChar = NSF20FunctionKey;
			break;
		case kVK_Delete:
			myChar = NSDeleteFunctionKey;
			break;
		case kVK_Home:
			myChar = NSHomeFunctionKey;
			break;
		case kVK_End:
			myChar = NSEndFunctionKey;
			break;
		case kVK_PageUp:
			myChar = NSPageUpFunctionKey;
			break;
		case kVK_PageDown:
			myChar = NSPageDownFunctionKey;
			break;
		case kVK_Help:
			myChar = NSHelpFunctionKey;
			break;
	}

	return myChar ? [NSString stringWithFormat:@"%C",myChar] : [PRLHotKey stringForKey:keyCode];
}

+ (NSString *)stringForKeyCode:(NSUInteger)keyCode modifiers:(NSUInteger)modifiers
{
	if (keyCode || modifiers)
	{
		NSMutableString *s = [NSMutableString stringWithCapacity:16];
		NSString *key = nil;
		if (NSControlKeyMask & modifiers)
			[s appendString:@"⌃"];
		if (NSShiftKeyMask & modifiers)
			[s appendString:@"⇧"];
		if (NSAlternateKeyMask & modifiers)
			[s appendString:@"⌥"];
		if (NSCommandKeyMask & modifiers)
			[s appendString:@"⌘"];
		if (NSFunctionKeyMask & modifiers)
			[s appendString:@"fn"];
		if ([s length])
			[s appendString:@" "];
		switch (keyCode)
		{
			case kVK_ANSI_KeypadClear:
				key = @"Clear";
				break;
			case kVK_Return:
				key = @"Return";
				break;
			case kVK_Tab:
				key = @"Tab";
				break;
			case kVK_Space:
				key = @"Space";
				break;
			case kVK_Delete:
				key = @"⌫";
				break;
			case kVK_Escape:
				key = @"⎋";
				break;
			case kVK_F1:
				key = @"F1";
				break;
			case kVK_F2:
				key = @"F2";
				break;
			case kVK_F3:
				key = @"F3";
				break;
			case kVK_F4:
				key = @"F4";
				break;
			case kVK_F5:
				key = @"F5";
				break;
			case kVK_F6:
				key = @"F6";
				break;
			case kVK_F7:
				key = @"F7";
				break;
			case kVK_F8:
				key = @"F8";
				break;
			case kVK_F9:
				key = @"F9";
				break;
			case kVK_F10:
				key = @"F10";
				break;
			case kVK_F11:
				key = @"F11";
				break;
			case kVK_F12:
				key = @"F12";
				break;
			case kVK_F13:
				key = @"F13";
				break;
			case kVK_F14:
				key = @"F14";
				break;
			case kVK_F15:
				key = @"F15";
				break;
			case kVK_F16:
				key = @"F16";
				break;
			case kVK_F17:
				key = @"F17";
				break;
			case kVK_F18:
				key = @"F18";
				break;
			case kVK_F19:
				key = @"F19";
				break;
			case kVK_F20:
				key = @"F20";
				break;
			case kVK_Home:
				key = @"Home";
				break;
			case kVK_ForwardDelete:
				key = @"⌦";
				break;
			case kVK_LeftArrow:
				key = @"←";
				break;
			case kVK_RightArrow:
				key = @"→";
				break;
			case kVK_UpArrow:
				key = @"↑";
				break;
			case kVK_DownArrow:
				key = @"↓";
				break;
			case kVK_PageUp:
				key = @"PageUp";
				break;
			case kVK_PageDown:
				key = @"PageDown";
				break;
			case kVK_Help:
				key = @"Help";
				break;
			case kVK_End:
				key = @"End";
				break;
		}
		if ([key length])
		{
			[_keyCodeLookupDictionary setObject:[NSNumber numberWithUnsignedInteger:keyCode] forKey:key];
		}
		NSString *alternateKey = [PRLHotKey keyEquivalentStringForMenuForKeyCode:keyCode modifiers:modifiers];
		NSString *alternateKeyUpper = @"";
		if ([alternateKey length])
		{
			alternateKeyUpper = [alternateKey uppercaseString];
			[_keyCodeLookupDictionary setObject:[NSNumber numberWithUnsignedInteger:keyCode] forKey:alternateKey];
			if (![alternateKeyUpper isEqualToString:alternateKey])
			{
				[_keyCodeLookupDictionary setObject:[NSNumber numberWithUnsignedInteger:keyCode] forKey:alternateKeyUpper];
			}
		}

		[s appendString:[key length] ? key : alternateKeyUpper];
		return [s copy];
	}
	else
		return @"";
}

/* Returns string representation of key, if it is printable.*/
+ (NSString *)stringForKey:(CGKeyCode) keyCode
{
	TISInputSourceRef currentKeyboard = TISCopyCurrentKeyboardInputSource();
	CFDataRef layoutData = TISGetInputSourceProperty(currentKeyboard, kTISPropertyUnicodeKeyLayoutData);
	if (!layoutData)
	{

		// Can't get unicode keyboard layout, try current ASCII Capable layout"
		CFRelease(currentKeyboard);
		currentKeyboard = TISCopyCurrentASCIICapableKeyboardInputSource();
		layoutData = TISGetInputSourceProperty(currentKeyboard, kTISPropertyUnicodeKeyLayoutData);
	}

	if (!layoutData)
	{
		// KBH: Still can not retrieve keyboard layout data (May be Apple bug. Only seen on Japanese keyboard layouts). Current keyboard does not support unicode and there is no ascii capable keyboard available. Returning lookup from table

		// note this is a japanese lookup dictionary, called when attempt to get keyboard layout fails
		// bug could be had with other non-roman keyboards (not seen on others yet)
		NSString *myChar = [_fallbackKeyCodeDictionary objectForKey:[NSString stringWithFormat:@"%d",keyCode]];
		if (myChar)
		{
			return myChar;
		}
		else
		{
			[NSException raise:@"Character not found" format:@"Character not found for keyCode: %d",keyCode];
			return @"?";
		}
	}

	const UCKeyboardLayout *keyboardLayout = (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);

	UInt32 keysDown = 0;
	UniChar chars[4];
	UniCharCount realLength;

	UCKeyTranslate(keyboardLayout,
				   keyCode,
				   kUCKeyActionDisplay,
				   0,
				   LMGetKbdType(),
				   kUCKeyTranslateNoDeadKeysBit,
				   &keysDown,
				   sizeof(chars) / sizeof(chars[0]),
				   &realLength,
				   chars);
	CFRelease(currentKeyboard);

	return [NSString stringWithFormat:@"%C",chars[0]];
}


- (id)initWithKeyCode:(NSUInteger)keyCode modifiers:(NSUInteger)modifiers
{
	if (self = [super init])
	{
		_keyCode = keyCode;
		_modifiers = modifiers;
		_displayString = [PRLHotKey stringForKeyCode:_keyCode modifiers:_modifiers];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	NSUInteger keyCode = [[decoder decodeObjectForKey:@"keyCode"] unsignedIntegerValue];
	NSUInteger modifiers = [[decoder decodeObjectForKey:@"modifiers"] unsignedIntegerValue];
	return [self initWithKeyCode:keyCode modifiers:modifiers];
}

- (id)copyWithZone:(NSZone *)zone
{
	return [[PRLHotKey alloc] initWithKeyCode:self.keyCode modifiers:self.modifiers];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:[NSNumber numberWithUnsignedInteger:self.keyCode] forKey:@"keyCode"];
	[encoder encodeObject:[NSNumber numberWithUnsignedInteger:self.modifiers] forKey:@"modifiers"];
}

- (NSString *)keyEquivalentStringForMenuForHotKey
{
	return [PRLHotKey keyEquivalentStringForMenuForKeyCode:self.keyCode modifiers:self.modifiers];
}

- (NSString *)stringRepresentation
{
	return [PRLHotKey stringForKeyCode:self.keyCode modifiers:self.modifiers];
}

- (BOOL)isEqualTo:(id)object
{
	return (((PRLHotKey *)object).keyCode == self.keyCode) && (((PRLHotKey *)object).modifiers == self.modifiers);
}

- (NSString *)description
{
	if (_keyCode || _modifiers)
		return [NSString stringWithFormat:@"HotKey: modifiers: %lu, keycode: %lu, %@",(unsigned long)self.modifiers,(unsigned long)self.keyCode,[self displayString]];
	return @"empty hot key";
}

- (BOOL)isEmpty
{
	return((_keyCode == 0) && (_modifiers == 0));
}
@end

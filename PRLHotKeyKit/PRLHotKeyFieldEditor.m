//
//  PRLHotKeyFieldEditor.m
//  PRLHotKey
//
//  Created by Kevin Hayes on 11-12-09.
//  Copyright (c) 2011 Kevin Hayes. All rights reserved.
//

#import "Carbon/Carbon.h"
#import "PRLHotKeyFieldEditor.h"
#import "PRLHotKey.h"

@implementation PRLHotKeyFieldEditor

+ (instancetype)sharedHotKeyView
{
	static dispatch_once_t _singletonPredicate = 0;

	__strong static id theview = nil;
	dispatch_once(&_singletonPredicate, ^{
		theview = [[self alloc] init];
	});

	return theview;
}

- (id)init {
	if ((self = [super init])) {
		[self setFieldEditor:YES];
	}
	return self;
}

- (BOOL)isFieldEditor
{
	return YES;
}

- (void)keyDown:(NSEvent *)theEvent
{
	[self performKeyEquivalent:theEvent];
	if (theEvent.keyCode == kVK_Tab) // we don't process tabs, pass it up for proper navigation
	{
		[super keyDown:theEvent];
	}
	else
	{
		[self didChangeText];
		[[self window] makeFirstResponder:nil];
	}
}


- (BOOL)performKeyEquivalent:(NSEvent *)theEvent
{

	if (self == [[NSApp keyWindow] firstResponder])
	{
		if (theEvent.keyCode == kVK_Tab) // tabs are for navigating
			return [super performKeyEquivalent:theEvent];

		NSUInteger flags = theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask;

		if (((theEvent.keyCode == kVK_Delete) || (theEvent.keyCode == kVK_ForwardDelete)) && !flags)
		{
			// remove the hotKey
			self.string = @"";
		}
		else
		{
			PRLHotKey *hk = [[PRLHotKey alloc] initWithKeyCode:theEvent.keyCode modifiers:theEvent.modifierFlags];
			NSString *characters = [PRLHotKey stringForKeyCode:theEvent.keyCode modifiers:theEvent.modifierFlags];
			if (((flags == NSShiftKeyMask) || !flags) && !(([characters length] > 1) && [characters hasPrefix:@"F"])) // can't have a hotkey with just shift or nothing as a modifier (unless it's an F key) - that's crazy
				return YES;

			self.string = [hk displayString];
		}

		[self didChangeText];
		[[self window] makeFirstResponder:nil];
		return YES;
	}
	else
		return [super performKeyEquivalent:theEvent];
}

- (NSRange)selectionRangeForProposedRange:(NSRange)proposedSelRange //don't want to select a character in a hotkey string
                              granularity:(NSSelectionGranularity)granularity {
	return NSMakeRange(0, [self.string length]);
}
@end

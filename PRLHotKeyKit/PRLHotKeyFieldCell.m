//
//  PRLHotKeyFieldCell.m
//  PRLHotKey
//
//  Created by Parliant on 11/27/2013.
//
//

#import "PRLHotKeyFieldCell.h"
#import "PRLHotKeyFieldEditor.h"
#import "PRLHotKey.h"

@interface PRLHotKeyFormatter : NSFormatter
@end

@implementation PRLHotKeyFieldCell
- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder])
	{
		self.formatter = [[PRLHotKeyFormatter alloc] init];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[super encodeWithCoder:encoder];
}

- (id)copyWithZone:(NSZone *)zone
{
	PRLHotKeyFieldCell *newObject = [super copyWithZone:zone];
	newObject.formatter = [[PRLHotKeyFormatter alloc] init];
	return newObject;
}

- (id)initTextCell:(NSString *)aString
{
	if (self = [super initTextCell:aString])
	{
		self.formatter = [[PRLHotKeyFormatter alloc] init];
	}
	return self;
}

- (NSTextView *)fieldEditorForView:(NSView *)aControlView
{
	return [PRLHotKeyFieldEditor sharedHotKeyView];
}

@end

@implementation PRLHotKeyFormatter
- (NSString *)stringForObjectValue:(id)object
{
	if (![object isKindOfClass:[PRLHotKey class]])
	{
		return nil;
	}

	return [object stringRepresentation];
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error
{
	*anObject = [PRLHotKey hotKeyForString:string];
	return YES;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)attributes
{
	NSString *string = [self stringForObjectValue:anObject];

    if  (!string) {
        return nil;
    }

    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}
@end


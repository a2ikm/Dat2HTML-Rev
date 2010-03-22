//
//  NSString+Utils.m
//

#import "NSString+Utils.h"


@implementation NSString (NSString_Utils)

- (NSRange)wholeRange
{
	return NSMakeRange(0, [self length]);
}


- (NSString *)stringByTrimmingWhitespacesAndNewlines
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

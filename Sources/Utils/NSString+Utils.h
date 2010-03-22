//
//  NSString+Utils.h
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_Utils)

- (NSRange)wholeRange;
- (NSString *)stringByTrimmingWhitespacesAndNewlines;

@end
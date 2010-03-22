//
//  LineReader.h
//

#import <Cocoa/Cocoa.h>
#import <stdio.h>

#define kReadLineMaxLength 8192

@interface LineReader : NSObject
{
	NSString			*vFilePath;
	NSStringEncoding	vEncoding;
	
	FILE				*vFile;
}

- (id)initWithFilePath:(NSString *)filePath encoding:(NSStringEncoding)encoding error:(NSError **)outError;
- (NSString *)filePath;
- (NSString *)nextLine;
- (void)setPointer:(int)pointer;

@end

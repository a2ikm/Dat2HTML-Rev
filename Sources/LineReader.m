//
//  LineReader.m
//

#import "LineReader.h"


@implementation LineReader

- (id)initWithFilePath:(NSString *)filePath encoding:(NSStringEncoding)encoding error:(NSError **)outError;
{
	if (self = [super init]) {
		vFilePath = [filePath copy];
		vEncoding = encoding;
		
		vFile = fopen([filePath UTF8String], "r");
		if (vFile == NULL) {
			[self release];
			*outError = [NSError errorWithDomain:@"LineReader"
											code:ferror(vFile)
										userInfo:nil];
		}
	}
	return self;
}

- (void)dealloc
{
	if (vFile != NULL) fclose(vFile);
	
	[vFilePath release];
	
	[super dealloc];
}

- (NSString *)filePath
{
	return vFilePath;
}

- (NSString *)nextLine
{
	char string[kReadLineMaxLength];
	
	if (fgets(string, kReadLineMaxLength, vFile) == NULL)
		return nil;
	else
		return [NSString stringWithCString:string encoding:vEncoding];
}

- (void)setPointer:(int)pointer
{
	fseek(vFile, pointer, SEEK_SET);
}

@end

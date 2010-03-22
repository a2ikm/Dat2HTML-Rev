//
//  NSFileManager+Utils.m
//


#import "NSFileManager+Utils.h"


@implementation NSFileManager (NSFileManager_Utils)

- (NSArray *)directoryContentsAtPath:(NSString *)path fullPath:(BOOL)flag
{
	NSArray *contents = [self directoryContentsAtPath:path];
	
	if (!flag)
		return contents;
	
	
	NSMutableArray *fullPaths = [NSMutableArray arrayWithCapacity:[contents count]];

	NSString *fileName = nil;
	NSEnumerator *en = [contents objectEnumerator];
	while (fileName = [en nextObject]) 
		[fullPaths addObject:[path stringByAppendingPathComponent:fileName]];
	
	return fullPaths;
}

@end

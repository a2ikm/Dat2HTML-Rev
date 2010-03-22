//
//  RF2chThreadDatReader.h
//  Dat2HTML Rev
//

#import <Foundation/Foundation.h>
#import <OgreKit/OgreKit.h>
#import "LineReader.h"

@class RF2chThreadItem;

@interface RF2chThreadDatReader : LineReader
{
	NSString	*vTitle;
	unsigned	vCount;
}

- (id)initWithFilePath:(NSString *)filePath;
- (NSString *)title;
- (RF2chThreadItem *)nextThreadItem;
- (void)markRestart;

@end

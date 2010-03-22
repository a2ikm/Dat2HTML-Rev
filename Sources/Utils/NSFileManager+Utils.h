//
//  NSFileManager+Utils.h
//


#import <Foundation/Foundation.h>


@interface NSFileManager (NSFileManager_Utils)

- (NSArray *)directoryContentsAtPath:(NSString *)path fullPath:(BOOL)flag;

@end

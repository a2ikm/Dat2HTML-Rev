//
//  RF2chThreadItem.h
//  Dat2HTML Rev
//

#import <Foundation/Foundation.h>

extern const NSString *RF2chThreadItemNumberKey;
extern const NSString *RF2chThreadItemNameKey;
extern const NSString *RF2chThreadItemEmailKey;
extern const NSString *RF2chThreadItemBodyKey;
extern const NSString *RF2chThreadItemDateKey;
extern const NSString *RF2chThreadItemIDKey;
extern const NSString *RF2chThreadItemBeKey;



@interface RF2chThreadItem : NSObject
{
	NSMutableDictionary *vProperties;
}

+ (NSArray *)threadItemPropertyKeys;

- (id)initWithProperties:(NSDictionary *)properties;
- (NSString *)propertyForKey:(NSString *)key;

@end

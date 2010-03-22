//
//  RF2chThreadItem.m
//  Dat2HTML Rev
//

#import "RF2chThreadItem.h"


const NSString *RF2chThreadItemNumberKey	= @"ThreadItemNumber";
const NSString *RF2chThreadItemNameKey		= @"ThreadItemName";
const NSString *RF2chThreadItemEmailKey		= @"ThreadItemEmail";
const NSString *RF2chThreadItemBodyKey		= @"ThreadItemBody";
const NSString *RF2chThreadItemDateKey		= @"ThreadItemDate";
const NSString *RF2chThreadItemIDKey		= @"ThreadItemID";
const NSString *RF2chThreadItemBeKey		= @"ThreadItemBe";


@implementation RF2chThreadItem

+ (NSArray *)threadItemPropertyKeys
{
	return [NSArray arrayWithObjects:RF2chThreadItemNumberKey,
		RF2chThreadItemNameKey, RF2chThreadItemEmailKey,
		RF2chThreadItemBodyKey, RF2chThreadItemDateKey,
		RF2chThreadItemIDKey, RF2chThreadItemBeKey, nil];
}

- (id)initWithProperties:(NSDictionary *)properties
{
	if (self = [super init]) {
		vProperties = [properties copyWithZone:[self zone]];
	}
	return self;
}

- (void)dealloc
{
	[vProperties release];
	[super dealloc];
}

- (NSString *)propertyForKey:(NSString *)key
{
	return (NSString *)[vProperties objectForKey:key];
}

- (NSString *)description
{
	return [vProperties description];
}

@end

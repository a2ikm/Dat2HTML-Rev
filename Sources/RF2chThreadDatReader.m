//
//  RF2chThreadDatReader.m
//  Dat2HTML Rev
//

#import "RF2chThreadDatReader.h"
#import "RF2chThreadItem.h"
#import "NSString+Utils.h"


@implementation RF2chThreadDatReader

// res anchor
OGRegularExpression	*_anchorRegex	= nil;
NSString			*_anchorReplace = nil;

OGRegularExpression	*_autoLinkFTPRegex	= nil;
NSString			*_autoLinkFTPReplace	= nil;

OGRegularExpression	*_autoLinkHTTPRegex	= nil;
NSString			*_autoLinkHTTPReplace	= nil;

OGRegularExpression	*_autoLinkHTTPSRegex	= nil;
NSString			*_autoLinkHTTPSReplace	= nil;

+ (void)initialize
{
	// <a href="../test/read.cgi/mac/1124761121/17-18" target="_blank"> => <a href="#res17" class="resPointer">
	_anchorRegex	= [[OGRegularExpression alloc] initWithString:@"<a href=\"[-./0-9a-zA-Z]+/([0-9]+)(?:-[0-9])?\" target=\"_blank\">"];
	_anchorReplace = [[NSString alloc] initWithString:@"<a href=\"#res\\1\" class=\"resPointer\">"];
	
	// autoLink ftp urls
	_autoLinkFTPRegex = [[OGRegularExpression alloc] initWithString:@"(ftp://[-.,%/+?$~@&=_:#0-9a-zA-Z]+)"];
	_autoLinkFTPReplace = [[NSString alloc] initWithString:@"<a href=\"\\1\" class=\"outLink\">\\1</a>"];
	
	// autoLink http urls
	_autoLinkHTTPRegex = [[OGRegularExpression alloc] initWithString:@"((?:h?ttp)(://[-.,%/+?$~@&=_:#0-9a-zA-Z]+))"];
	_autoLinkHTTPReplace = [[NSString alloc] initWithString:@"<a href=\"http\\2\" class=\"outLink\">\\1</a>"];
	
	// autoLink https urls
	_autoLinkHTTPSRegex = [[OGRegularExpression alloc] initWithString:@"((?:h?ttps)(://[-.,%/+?$~@&=_:#0-9a-zA-Z]+))"];
	_autoLinkHTTPSReplace = [[NSString alloc] initWithString:@"<a href=\"https\\2\" class=\"outLink\">\\1</a>"];
}

- (id)initWithFilePath:(NSString *)filePath
{
	if (self = [super initWithFilePath:filePath encoding:NSShiftJISStringEncoding error:NULL]) {
		vCount = 0;
		vTitle = [[[[[self nextLine] componentsSeparatedByString:@"<>"] lastObject] stringByTrimmingWhitespacesAndNewlines] copy];
		[self markRestart];
	}
	return self;
}

- (void)dealloc
{
	[vTitle release];
	[super dealloc];
}

- (NSString *)title
{
	return vTitle;
}

- (RF2chThreadItem *)nextThreadItem
{
	NSString *line = [self nextLine];
	if (!line) return nil;
	
	NSMutableDictionary *properties = [NSMutableDictionary dictionary];
	
	[properties setObject:[NSString stringWithFormat:@"%d", ++vCount]
				   forKey:RF2chThreadItemNumberKey];
	
	NSArray *components	= [line componentsSeparatedByString:@"<>"];
	
	[properties setObject:[components objectAtIndex:0]
				   forKey:RF2chThreadItemNameKey];
	[properties setObject:[components objectAtIndex:1]
				   forKey:RF2chThreadItemEmailKey];
	
	// rewrite anchors in body
	NSString *body = [_anchorRegex replaceAllMatchesInString:[components objectAtIndex:3]
												  withString:_anchorReplace];
	body = [_autoLinkFTPRegex replaceAllMatchesInString:body
										  withString:_autoLinkFTPReplace];
	body = [_autoLinkHTTPRegex replaceAllMatchesInString:body
										  withString:_autoLinkHTTPReplace];
	body = [_autoLinkHTTPSRegex replaceAllMatchesInString:body
										  withString:_autoLinkHTTPSReplace];
										  
//	NSLog(@"%@", body);
	
	[properties setObject:body
				   forKey:RF2chThreadItemBodyKey];
	
	
	// 3rd section (index == 2) is in cases: `DATE ID:foo Be:bar`, `DATE ID:foo`, or `DATE`.
	// to tokenize this, split the section by prefixes: `ID:` and `Be:`.
	
	// initialize ID and Be
	[properties setObject:@"" forKey:RF2chThreadItemIDKey];
	[properties setObject:@"" forKey:RF2chThreadItemBeKey];
	
	// DATE
	NSArray *dateAndOthers = [[components objectAtIndex:2] componentsSeparatedByString:@" ID:"];
	[properties setObject:[dateAndOthers objectAtIndex:0]
				   forKey:RF2chThreadItemDateKey];
	
	// ID:foo
	if ([dateAndOthers count] > 1) {
		NSArray *idAndOthers = [[dateAndOthers objectAtIndex:1] componentsSeparatedByString:@" Be:"];
		[properties setObject:[idAndOthers objectAtIndex:0]
					   forKey:RF2chThreadItemIDKey];

		// Be:bar
		if ([idAndOthers count] > 1) {
			[properties setObject:[idAndOthers objectAtIndex:1]
						   forKey:RF2chThreadItemBeKey];
		}
	}
	
	return [[[RF2chThreadItem alloc] initWithProperties:properties] autorelease];
}

- (void)markRestart
{
	vCount = 0;
	[self setPointer:0];
}

@end

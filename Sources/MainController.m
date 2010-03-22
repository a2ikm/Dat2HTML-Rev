//
//  MainController.m
//  Dat2HTML Rev
//

#import "MainController.h"
#import "NSString+Utils.h"
#import "NSFileManager+Utils.h"
#import "RF2chThreadDatReader.h"
#import "RF2chThreadItem.h"

@interface MainController (Private)

/*
 a member of `files` must be composed from file full paths.
 */
- (void)addFiles:(NSArray *)files;

@end


@implementation MainController

- (id)init
{
	if (self = [super init]) {
		vFileList = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[vFileList release];
	[super dealloc];
}

- (IBAction)showAcknowledgement:(id)sender
{
	[[NSWorkspace sharedWorkspace] openFile:[[NSBundle mainBundle] pathForResource:@"Acknowledgement.rtf" ofType:nil]];
}

- (IBAction)clear:(id)sender
{
	[vFileList removeAllObjects];	
	[fileListView reloadData];
}

- (IBAction)convert:(id)sender
{
	NSString *template = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:DefaultHTMLTemplate ofType:nil]];
	
	NSEnumerator *en = [vFileList objectEnumerator];
	NSMutableDictionary *item = nil;
	while (item = [en nextObject]) {

		RF2chThreadDatReader *reader = [[RF2chThreadDatReader alloc] initWithFilePath:[item objectForKey:@"inputFileName"]];
		if (!reader) continue;
		
		NSMutableString *resultString = [[NSMutableString alloc] initWithString:@""];
		NSMutableString *aTemplate = [template mutableCopy];
		
		[aTemplate replaceOccurrencesOfString:@"{!ApplicationName}"
								   withString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
									  options:NSLiteralSearch
										range:[aTemplate wholeRange]];
		[aTemplate replaceOccurrencesOfString:@"{!ApplicationVersion}"
								   withString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
									  options:NSLiteralSearch
										range:[aTemplate wholeRange]];
		[aTemplate replaceOccurrencesOfString:@"{!ApplicationWebsite}"
								   withString:ApplicationWebsite
									  options:NSLiteralSearch
										range:[aTemplate wholeRange]];
		
		[aTemplate replaceOccurrencesOfString:@"{!ThreadTitle}"
								   withString:[reader title]
									  options:NSLiteralSearch
										range:[aTemplate wholeRange]];
		
		NSArray *parts = [aTemplate componentsSeparatedByString:TemplateSeparator];
		[resultString appendString:[parts objectAtIndex:0]];
		
		RF2chThreadItem *threadItem = nil;
		while (threadItem = [reader nextThreadItem]) {
			
			NSMutableString *aThreadItemTemplate = [[parts objectAtIndex:1] mutableCopy];
			
			NSString *key = nil;
			NSEnumerator *propertyEn = [[RF2chThreadItem threadItemPropertyKeys] objectEnumerator];
			while (key = [propertyEn nextObject]) {
				// RF2chThreadItemFOOKey corresponds to {!ThreadItemFOO}
				[aThreadItemTemplate replaceOccurrencesOfString:[NSString stringWithFormat:@"{!%@}", key]
													 withString:[threadItem propertyForKey:key]
														options:NSLiteralSearch
														  range:[aThreadItemTemplate wholeRange]];
			}
			[resultString appendString:aThreadItemTemplate];
			[aThreadItemTemplate release];
		}
		
		[resultString appendString:[parts objectAtIndex:2]];
		
		[reader release];
		[aTemplate release];
		
		
		// --- output
		[resultString writeToFile:[item objectForKey:@"outputFileName"]
					   atomically:NO
						 encoding:NSUTF8StringEncoding
							error:NULL];
		[resultString release];
	}
	
	[template release];
	
	[self clear:self];
}

- (IBAction)remove:(id)sender
{
	int selectedIndex = [fileListView selectedRow];
	
	if (selectedIndex < 0)
		return;
	
	[vFileList removeObjectAtIndex:selectedIndex];
	[fileListView reloadData];
}

- (void)awakeFromNib
{
	[fileListView registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
}

- (NSMutableArray *)fileList
{
	return vFileList;
}

- (void)setFileList:(NSMutableArray *)fileList
{
	[fileList retain];
	[vFileList release];
	vFileList = fileList;
}


#pragma mark Data Source

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [vFileList count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
	return [[vFileList objectAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];
}

#pragma mark Drag'n'drop

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
	return NO;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)operation
{
	NSPasteboard *pboard = [info draggingPasteboard];
	if ([pboard availableTypeFromArray:[NSArray arrayWithObject:NSFilenamesPboardType]])
		return NSDragOperationLink;
	else
		return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation
{
	NSPasteboard* pboard = [info draggingPasteboard];
	
	if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
		[self addFiles:[pboard propertyListForType:NSFilenamesPboardType]];
		[fileListView reloadData];
		return YES;
	}
	
	return NO;
}

- (void)addFiles:(NSArray *)files
{
	NSFileManager *fm = [NSFileManager defaultManager];
	
	NSString *inputFileName = nil;
	NSString *outputFileName = nil;
	NSEnumerator *en = [files objectEnumerator];
	while (inputFileName = [en nextObject]) {
		outputFileName = [[inputFileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"html"];
		NSString *fileType = [[fm fileAttributesAtPath:inputFileName
										  traverseLink:NO] objectForKey:NSFileType];
		if ([fileType isEqualToString:NSFileTypeRegular]) {
			NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
			[dic setObject:inputFileName
					forKey:@"inputFileName"];
			[dic setObject:outputFileName
					forKey:@"outputFileName"];

			if (![vFileList containsObject:dic])
				[vFileList addObject:dic];

			[dic release];
			
		} else if ([fileType isEqualToString:NSFileTypeDirectory]) {
			[self addFiles:[fm directoryContentsAtPath:inputFileName
											  fullPath:YES]];
		}
	}
}

@end

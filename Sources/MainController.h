//
//  MainController.h
//  Dat2HTML Rev
//

#import <Cocoa/Cocoa.h>

#define DefaultHTMLTemplate	@"DefaultHTMLTemplate"
#define TemplateSeparator	@"<!--__SEPARATOR__-->"
#define ApplicationWebsite	@"http://aerial.st/software/dat2html_dev/"

@interface MainController : NSObject
{
    IBOutlet NSPopUpButton	*encodingSelector;
    IBOutlet NSTableView	*fileListView;
	
	NSMutableArray			*vFileList;
}

- (IBAction)showAcknowledgement:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)convert:(id)sender;
- (IBAction)remove:(id)sender;

- (NSMutableArray *)fileList;
- (void)setFileList:(NSMutableArray *)fileList;

@end

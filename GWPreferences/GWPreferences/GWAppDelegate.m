
#import "GWAppDelegate.h"

@implementation GWAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}

- (IBAction) openPreferences:(id)sender {
	if(!self.prefsWindow) {
		self.prefsWindow = [[GWPrefsWindowController alloc] initWithWindowNibName:@"GWPrefsWindowController"];
	}
	[self.prefsWindow showWindow:nil];
}

@end

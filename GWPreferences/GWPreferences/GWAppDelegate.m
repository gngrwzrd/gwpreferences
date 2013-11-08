
#import "GWAppDelegate.h"

@implementation GWAppDelegate

- (IBAction) openPreferences:(id)sender {
	GWPrefsWindowController * p = [[GWPrefsWindowController alloc] initWithWindowNibName:@"GWPrefsWindowController"];
	//[p showWindow:nil];
	[p showWindowSelectedIdentifier:@"CacheSettings"];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return TRUE;
}

@end

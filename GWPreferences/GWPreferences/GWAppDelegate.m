
#import "GWAppDelegate.h"

@implementation GWAppDelegate

- (IBAction) openPreferences:(id)sender {
	self.prefsWindow = [[GWPrefsWindowController alloc] initWithWindowNibName:@"GWPrefsWindowController"];
	[self.prefsWindow showWindowAtSelectedIdentifier:@"CacheSettings"];
	self.prefsWindow.window.delegate = self;
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return TRUE;
}

- (void) windowWillClose:(NSNotification *)notification {
	NSLog(@"window will close");
	
	/*
	CFTypeRef pw = (__bridge_retained CFTypeRef)self.prefsWindow.window;
	CFBridgingRelease(pw);
	
	CFTypeRef pw2 = (__bridge_retained CFTypeRef)self.prefsWindow;
	CFBridgingRelease(pw2);
	*/
	 
	self.prefsWindow = nil;
}

@end

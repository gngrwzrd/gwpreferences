
#import <Cocoa/Cocoa.h>
#import "GWPrefsWindowController.h"

@interface GWAppDelegate : NSObject <NSApplicationDelegate>
@property (assign) IBOutlet NSWindow * window;
@property GWPrefsWindowController * prefsWindow;

@end

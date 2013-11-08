
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface GWPrefsWindowController : NSWindowController {
	NSMutableDictionary * _instances;
	__weak NSViewController * _currentViewController;
	__weak NSViewController * _nextViewController;
}

@property NSDictionary * viewControllerClasses;
@property (weak) IBOutlet NSToolbar * toolbar;

@end

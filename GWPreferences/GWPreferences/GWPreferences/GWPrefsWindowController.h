
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@protocol GWPrefsWindowViewControllerExtras
- (NSString *) titleForWindow;
@end

@interface GWPrefsWindowController : NSWindowController {
	NSMutableDictionary * _instances;
	__weak NSViewController * _currentViewController;
	__weak NSViewController * _nextViewController;
	id eventMonitor;
	NSString * _firstIdentifier;
}

@property NSDictionary * viewControllerClasses;
@property (weak) IBOutlet NSToolbar * toolbar;

- (void) showWindowAtFirstPreference;
- (void) showWindowSelectedIdentifier:(NSString *) identifier;

@end

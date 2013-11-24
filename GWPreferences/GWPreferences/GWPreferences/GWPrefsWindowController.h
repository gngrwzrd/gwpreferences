
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@protocol GWPrefsWindowViewControllerExtras
- (NSString *) titleForWindow;
@end

@interface GWPrefsWindowController : NSWindowController  <NSWindowDelegate> {
	NSMutableDictionary * _instances;
	__unsafe_unretained NSViewController * _currentViewController;
	__unsafe_unretained NSViewController * _nextViewController;
	id eventMonitor;
	NSString * _firstIdentifier;
}

@property NSDictionary * viewControllerClasses;
@property (assign) IBOutlet NSToolbar * toolbar;

- (void) showWindowAtFirstPreference;
- (void) showWindowAtSelectedIdentifier:(NSString *) identifier;
- (IBAction) toolbarItemPressed:(id)sender;
- (NSToolbarItem *) firstPreference;
- (NSToolbarItem *) itemForIdentifier:(NSString *) identier;

@end

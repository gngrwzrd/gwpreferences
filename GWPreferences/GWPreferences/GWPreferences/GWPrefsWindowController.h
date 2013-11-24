
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@protocol GWPrefsWindowViewControllerExtras
- (NSString *) titleForWindow;
@end

@interface GWPrefsWindowController : NSWindowController  <NSWindowDelegate> {
	NSMutableDictionary * _instances;
	NSString * _firstIdentifier;
	id eventMonitor;
	__unsafe_unretained NSViewController * _currentViewController;
	__unsafe_unretained NSViewController * _nextViewController;
}

@property NSDictionary * viewControllerClasses;
@property (assign) IBOutlet NSToolbar * toolbar;

- (void) showWindowAtFirstPreference;
- (void) showWindowAtSelectedIdentifier:(NSString *) identifier;
- (IBAction) toolbarItemPressed:(id)sender;
- (NSToolbarItem *) firstPreference;
- (NSToolbarItem *) itemForIdentifier:(NSString *) identifier;

@end

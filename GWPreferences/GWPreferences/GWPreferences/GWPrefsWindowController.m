
#import "GWPrefsWindowController.h"

@interface GWPrefsWindowController ()
@end

@implementation GWPrefsWindowController

- (void) awakeFromNib {
	_instances = [NSMutableDictionary dictionary];
	
	//if toolbar outlet isn't set nothing will work.
	if(!self.toolbar) {
		NSException * exc = [NSException exceptionWithName:@"NilReference" reason:@"The toolbar IBOutlet is not set." userInfo:nil];
		NSLog(@"%@",exc);
		@throw exc;
	}
	
	//get first toolbar item and show it's view controller.
	NSString * firstIdentifier = [[[self.toolbar items] objectAtIndex:0] itemIdentifier];
	if(_firstIdentifier) {
		firstIdentifier = _firstIdentifier;
	}
	[self _switchViewControllersWithIdentifier:firstIdentifier];
	
	//setup a key handler event monitor to watch for escape key
	NSEvent * (^handler)(NSEvent *) = ^(NSEvent * theEvent) {
		NSWindow * targetWindow = theEvent.window;
		if(targetWindow != self.window) {
			return theEvent;
		}
		NSEvent * result = theEvent;
		if(theEvent.keyCode == 53) {
			[self.window performClose:nil];
			result = nil;
		}
		return result;
	};
	
	eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:handler];
}

- (void) showWindowAtSelectedIdentifier:(NSString *) identifier; {
	_firstIdentifier = identifier;
	[self showWindow:nil];
	[self _switchViewControllersWithIdentifier:identifier];
}

- (void) showWindowAtFirstPreference {
	NSString * firstIdentifier = [[[self.toolbar items] objectAtIndex:0] itemIdentifier];
	if(!firstIdentifier) {
		[self showWindow:nil];
	} else {
		[self showWindowAtSelectedIdentifier:firstIdentifier];
	}
}

- (IBAction) toolbarItemPressed:(id)sender {
	//get item identifier and switch to it
	NSToolbarItem * item = (NSToolbarItem *)sender;
	NSString * identifier = item.itemIdentifier;
	[self _switchViewControllersWithIdentifier:identifier];
}

- (void) switchTitles:(NSViewController *) instance {
	//grab title if it's available
	if([instance conformsToProtocol:@protocol(GWPrefsWindowViewControllerExtras)]) {
		NSViewController <GWPrefsWindowViewControllerExtras> * inst = (NSViewController<GWPrefsWindowViewControllerExtras>*)instance;
		if([inst respondsToSelector:@selector(titleForWindow)]) {
			NSString * title = [inst performSelector:@selector(titleForWindow)];
			self.window.title = title;
		}
	}
}

- (void) _switchViewControllersWithIdentifier:(NSString *) identifier {
	NSString * xibpath = [[NSBundle mainBundle] pathForResource:identifier ofType:@"xib"];
	NSString * nibpath = [[NSBundle mainBundle] pathForResource:identifier ofType:@"nib"];
	if(!xibpath && !nibpath) {
		NSLog(@"NibNotFound: Nib '%@' not found.",identifier);
		return;
	}
	
	//select toolbar item
	[self.toolbar setSelectedItemIdentifier:identifier];
	
	//grab an existing instance if it's available
	Class cls = NSClassFromString(identifier);
	id instance = [_instances objectForKey:identifier];
	if(!instance) {
		instance = [[cls alloc] initWithNibName:identifier bundle:nil];
		[_instances setObject:instance forKey:identifier];
	}
	
	[self _switchViewControllers:instance];
}

- (void) _switchViewControllers:(NSViewController *) newvc {
	if(_currentViewController == newvc) {
		return;
	}
	
	_nextViewController = newvc;
	[self switchTitles:newvc];
	
	if(_currentViewController) {
		[_currentViewController.view removeFromSuperview];
		[self addNextViewController];
	} else {
		[self addNextViewController];
	}
}

- (void) addNextViewController {
	NSRect cwf = self.window.frame;
	NSRect ccf = ((NSView*)self.window.contentView).frame;
	NSRect nvf = _nextViewController.view.frame;
	
	NSInteger wd = NSWidth(ccf) - NSWidth(nvf);
	NSInteger hd = NSHeight(ccf) - NSHeight(nvf);
	
	if(hd < 0) {
		cwf.size.height += hd*-1;
		cwf.origin.y -= hd*-1;
	} else {
		cwf.size.height -= hd;
		cwf.origin.y += hd;
	}
	
	if(wd < 0) {
		cwf.size.width += wd*-1;
	} else {
		cwf.size.width -= wd;
	}
	
	[self.window setFrame:cwf display:TRUE animate:TRUE];
	
	_currentViewController = _nextViewController;
	[[self.window contentView] addSubview:_nextViewController.view];
}

- (NSToolbarItem *) firstPreference; {
	return [[self.toolbar items] objectAtIndex:0];
}

- (NSToolbarItem *) itemForIdentifier:(NSString *) identifier {
	for(NSToolbarItem * item in self.toolbar.items) {
		if([item.itemIdentifier isEqualToString:identifier]) {
			return item;
		}
	}
	return NULL;
}

- (void) dealloc {
	NSLog(@"dealloc!");
	[NSEvent removeMonitor:eventMonitor];
	eventMonitor = nil;
	_instances = nil;
}

@end

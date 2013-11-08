
#import "GWPrefsWindowController.h"

@interface GWPrefsWindowController ()
@end

@implementation GWPrefsWindowController

- (void) awakeFromNib {
	_instances = [NSMutableDictionary dictionary];
	
	//if toolbar outlet isn't set nothing will work.
	if(!self.toolbar) {
		NSException * exc = [NSException exceptionWithName:@"NilReference" reason:@"The toolbar IBOutlet is not set." userInfo:nil];
		@throw exc;
	}
	
	//get first toolbar item and show it's view controller.
	NSString * firstIdentifier = [[[self.toolbar items] objectAtIndex:0] itemIdentifier];
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

- (IBAction) toolbarItemPressed:(id)sender {
	//get item identifier and switch to it
	NSToolbarItem * item = (NSToolbarItem *)sender;
	NSString * identifier = item.itemIdentifier;
	[self _switchViewControllersWithIdentifier:identifier];
}

- (void) _switchViewControllersWithIdentifier:(NSString *) identifier {
	//grab an existing instance if it's available
	NSViewController * instance = [_instances objectForKey:identifier];
	if(!instance) {
		instance = [[NSViewController alloc] initWithNibName:identifier bundle:nil];
		instance.view.wantsLayer = TRUE;
		[_instances setObject:instance forKey:identifier];
	}
	[self _switchViewControllers:instance];
}

- (void) _switchViewControllers:(NSViewController *) newvc {
	if(_currentViewController == newvc) {
		return;
	}
	_nextViewController = newvc;
	if(_currentViewController) {
		[CATransaction begin];
		[CATransaction setCompletionBlock:^{
			[_currentViewController.view removeFromSuperview];
			[self addNextViewController];
		}];
		_currentViewController.view.layer.opacity = 0;
		[CATransaction commit];
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
	
	_nextViewController.view.layer.opacity = 0;
	[CATransaction begin];
	[CATransaction setCompletionBlock:^{
		_currentViewController = _nextViewController;
		[[self.window contentView] addSubview:_nextViewController.view];
	}];
	_nextViewController.view.layer.opacity = 1;
	[CATransaction commit];
}

- (void) dealloc {
	NSLog(@"dealloc");
	[NSEvent removeMonitor:eventMonitor];
	eventMonitor = nil;
	_instances = nil;
}

@end

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation RootTabMaskController

-(instancetype)init {
    if (self = [super init]) {
        controller = [RootViewController new];
        [self addChildViewController: controller];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    controller.view.frame = self.view.bounds;
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    if (@available(iOS 11, *)) {
        mask = [[UIView alloc] initWithFrame:self.view.bounds];
        mask.translatesAutoresizingMaskIntoConstraints = NO;
        if (@available(iOS 13, *)) {
            mask.backgroundColor = [UIColor colorWithDynamicProvider:^(UITraitCollection *collection) {
                if (collection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    return [UIColor colorWithWhite:.31 alpha:.85];
                } else {
                    return [UIColor colorWithWhite:.75 alpha:.85];
                }
            }];
        } else {
            mask.backgroundColor = [UIColor colorWithWhite:.75 alpha:.85];
        }
        [self.view addSubview: mask];
        [self.view bringSubviewToFront: mask];
    }
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = self.view.safeAreaInsets;
        if (insets.bottom != 0) {
            mask.hidden = false;
            mask.frame = CGRectMake(0, self.view.bounds.size.height - insets.bottom, self.view.bounds.size.width, insets.bottom);
            [self.view bringSubviewToFront: mask];
        } else {
            mask.hidden = true;
        }
    }
    if (controller.view != nil) {
        controller.view.frame = self.view.bounds;
    }
}

@end

@implementation TopAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].rowHeight = 44;
    [UITableView appearance].sectionHeaderHeight = 23;
    [UITableView appearance].sectionFooterHeight = 23;
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
	// Create UIWindow
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	// Allocate the navigation controller
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:[RootTabMaskController new]];
	// Set the navigation controller as the window's root view controller and display.
	self.window.rootViewController = self.navigationController;
	[self.window makeKeyAndVisible];
	return YES;
}
/*
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
}
*/
@end

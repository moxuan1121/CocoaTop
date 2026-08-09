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
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.opaque = YES;
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

    // Present a lightweight first frame before CocoaTop performs its initial
    // process scan. Some RootHide split-screen launchers skip the system launch
    // storyboard snapshot, so keep the same artwork visible inside the app too.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.opaque = YES;

    UIViewController *launchController = [UIViewController new];
    launchController.view.backgroundColor = [UIColor whiteColor];
    launchController.view.opaque = YES;
    self.window.rootViewController = launchController;

    UIView *launchOverlay = [[UIView alloc] initWithFrame:self.window.bounds];
    launchOverlay.backgroundColor = [UIColor whiteColor];
    launchOverlay.opaque = YES;
    launchOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIImageView *launchArtwork = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchScreenArtwork"]];
    launchArtwork.frame = launchOverlay.bounds;
    launchArtwork.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    launchArtwork.contentMode = UIViewContentModeScaleAspectFill;
    launchArtwork.clipsToBounds = YES;
    [launchOverlay addSubview:launchArtwork];
    [self.window addSubview:launchOverlay];
    [self.window makeKeyAndVisible];

    // Give UIKit one render pass for the launch artwork before constructing the
    // process list, which can briefly block the main thread on a cold start.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:[RootTabMaskController new]];
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.view.opaque = YES;
        self.window.rootViewController = self.navigationController;
        [self.window addSubview:launchOverlay];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                launchOverlay.alpha = 0.0;
            } completion:^(BOOL finished) {
                [launchOverlay removeFromSuperview];
            }];
        });
    });
    return YES;
}
/*
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
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

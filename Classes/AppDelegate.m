//
//  AppDelegate.m
//  DroppableViewTest
//
//  Created by liu on 12-11-21.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    mWindow = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    mWindow.backgroundColor = [UIColor whiteColor];
    
    TestViewController* viewController = [[TestViewController alloc] init];
    [mWindow addSubview: viewController.view];
    
    [mWindow makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc
{
    [mWindow release];
    [mViewController release];
    
    [super dealloc];
}

@end

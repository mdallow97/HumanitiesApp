//
//  AppDelegate.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/25/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    LogInViewController *logInViewController;
    int viewWidth, viewHeight;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    logInViewController = [[LogInViewController alloc] init];
    self.window.rootViewController = logInViewController;
    
    logInViewController.view.backgroundColor = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    
    // Setup frames for ViewController
    viewWidth = logInViewController.view.frame.size.width;
    viewHeight = logInViewController.view.frame.size.height;
    
    int logInWidth = 100;
    int x = (viewWidth / 2) - (logInWidth / 2);
    CGRect logInFrame = CGRectMake(x, ((viewHeight / 3) * 2), logInWidth, 35);
    
    
    
    
    // Cancel button creation
    UIButton *logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    logInButton.titleLabel.font = [UIFont systemFontOfSize:30];
    logInButton.frame = logInFrame;
    [logInButton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [logInViewController.view addSubview:logInButton];
    
    
    
    return YES;
}

- (void) logIn
{
    if (![logInViewController logIn]) return;
    
    [logInViewController dismissViewControllerAnimated:YES completion:nil];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    UIViewController *mainViewController = [[ViewController alloc] init];
    UIViewController *personalPageController = [[PersonalPageViewController alloc] init];
    UIViewController *settingsController = [[SettingsTableViewController alloc] init];
    
    
    tbc.viewControllers = [NSArray arrayWithObjects:
                           mainViewController,
                           personalPageController,
                           settingsController,
                           nil];
    
    
    tbc.tabBar.tintColor = [UIColor blackColor];
    tbc.tabBar.barTintColor = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    self.window.rootViewController = tbc;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

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

// Application starts here
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
    
    int regWidth = 200;
    int regX = (viewWidth / 2) - (regWidth / 2);
    CGRect regFrame = CGRectMake(regX, ((viewHeight / 15) * 11), regWidth, 35);
    
    
    
    // Login button creation
    self.logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    self.logInButton.titleLabel.font = [UIFont systemFontOfSize:30];
    self.logInButton.frame = logInFrame;
    [self.logInButton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    
    // Register button creation
    self.regButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.regButton setTitle:@"New User? Register." forState:UIControlStateNormal];
    self.regButton.titleLabel.font = [UIFont systemFontOfSize:10];
    self.regButton.frame = regFrame;
    [self.regButton addTarget:self action:@selector(reg) forControlEvents:UIControlEventTouchUpInside];
    
    self.logInButton.hidden = NO;
    self.regButton.hidden = NO;
    
    [logInViewController hasParent:self];
    
    [logInViewController.view addSubview:self.logInButton];
    [logInViewController.view addSubview:self.regButton];
    
    
    
    return YES;
}

- (void) reg
{
    self.logInButton.hidden = YES;
    self.regButton.hidden = YES;
    if (![logInViewController registerNow])
    {
        return;
    }
}

- (void) logIn
{
    if (![logInViewController logIn]) return;
    
    [logInViewController dismissViewControllerAnimated:YES completion:nil];
    
    UITabBarController *tbc                     = [[UITabBarController alloc] init];
    UIViewController *mainViewController        = [[ViewController alloc] init];
    UIViewController *personalPageController    = [[PersonalPageViewController alloc] init];
    UIViewController *settingsController        = [[SettingsTableViewController alloc] init];
    
    
    tbc.viewControllers = [NSArray arrayWithObjects:
                           mainViewController,
                           personalPageController,
                           settingsController,
                           nil];
    
    
    tbc.tabBar.tintColor            = [UIColor blackColor];
    tbc.tabBar.barTintColor         = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    self.window.rootViewController  = tbc;
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

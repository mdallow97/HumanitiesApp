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
    LogInViewController *log_in_VC;
    int view_width, view_height;
}

// Application starts here
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    log_in_VC                           = [[LogInViewController alloc] init];
    self.window.rootViewController      = log_in_VC;
    log_in_VC.view.backgroundColor      = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    
    // Setup frames for ViewController
    view_width  = log_in_VC.view.frame.size.width;
    view_height = log_in_VC.view.frame.size.height;
    
    
    // Login button creation
    self.log_in_button                  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.log_in_button.titleLabel.font  = [UIFont systemFontOfSize:30];
    self.log_in_button.frame            = CGRectMake((view_width / 2) - 50, ((view_height / 3) * 2), 100, 35);
    [self.log_in_button setTitle:@"Log In" forState:UIControlStateNormal];
    [self.log_in_button addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    
    // Register button creation
    self.create_user_button                    = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.create_user_button.titleLabel.font    = [UIFont systemFontOfSize:10];
    self.create_user_button.frame              = CGRectMake((view_width / 2) - 100, ((view_height / 15) * 11), 200, 35);
    [self.create_user_button setTitle:@"New User? Register." forState:UIControlStateNormal];
    [self.create_user_button addTarget:self action:@selector(newUserRegistration) forControlEvents:UIControlEventTouchUpInside];
    
    // Make sure buttons show
    self.log_in_button.hidden       = NO;
    self.create_user_button.hidden  = NO;
    
    [log_in_VC hasParent:self];
    
    [log_in_VC.view addSubview:self.log_in_button];
    [log_in_VC.view addSubview:self.create_user_button];
    
    
    
    return YES;
}

- (void) newUserRegistration
{
    self.log_in_button.hidden       = YES;
    self.create_user_button.hidden  = YES;
    
    if (![log_in_VC enterRegistrationInfo]) return;
}

- (void) logIn
{
    if (![log_in_VC enterLogInCredentials]) return;
    
    [log_in_VC dismissViewControllerAnimated:YES completion:nil];
    
    UITabBarController *tbc                 = [[UITabBarController alloc] init];
    UIViewController *main_VC               = [[ViewController alloc] init];
    UIViewController *personal_page_VC      = [[PersonalPageViewController alloc] init];
    UIViewController *settings_VC           = [[SettingsTableViewController alloc] init];
    
    
    tbc.viewControllers = [NSArray arrayWithObjects:
                           main_VC,
                           personal_page_VC,
                           settings_VC,
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

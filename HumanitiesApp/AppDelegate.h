//
//  AppDelegate.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/25/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsTableViewController.h"
#import "ViewController.h"
#import "LogInViewController.h"
#import "PersonalPageViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property UIButton *logInButton;
@property UIButton *regButton;

- (void) logIn;

@end


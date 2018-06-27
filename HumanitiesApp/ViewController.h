//
//  ViewController.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/25/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeView.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

- (void) setup;
- (UITabBarItem *)tabBarItem;
- (void) viewDidLoad;
- (void) didReceiveMemoryWarning;
- (BOOL) textFieldShouldReturn:(UITextField *)textField;

@end


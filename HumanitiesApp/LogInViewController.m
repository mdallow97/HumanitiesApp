//
//  LogInViewController.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/27/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()


@end

@implementation LogInViewController
{
    int viewWidth, viewHeight;
    UITextField *username;
    UITextField *password;
}

- (void) setup
{
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
}

- (void) viewDidLoad
{
    [self setup];
    
    // Username text field frame setup
    int textFieldWidth = 250;
    int textFieldHeight = 40;
    int x = (viewWidth / 2) - (textFieldWidth / 2);
    int y = (viewHeight / 2) - (textFieldHeight / 2);
    y -= textFieldHeight;
    
    CGRect usernameFrame = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    y += (textFieldHeight + 10);
    CGRect passwordFrame = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    
    // Username text field
    username = [[UITextField alloc] initWithFrame:usernameFrame];
    username.borderStyle = UITextBorderStyleRoundedRect;
    username.tintColor = [UIColor blueColor];
    username.backgroundColor = [UIColor lightGrayColor];
    username.placeholder = @"Username";
    username.returnKeyType = UIReturnKeyNext;
    username.delegate = self;
    
    password = [[UITextField alloc] initWithFrame:passwordFrame];
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.tintColor = [UIColor blueColor];
    password.backgroundColor = [UIColor lightGrayColor];
    password.placeholder = @"Password";
    password.returnKeyType = UIReturnKeyGo;
    password.delegate = self;
    
    
    [self.view addSubview:username];
    [self.view addSubview:password];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == username) {
        textField = password;
        return NO;
    } else if (textField == password) {
        [textField resignFirstResponder];
    }
    
    return YES;
}



@end

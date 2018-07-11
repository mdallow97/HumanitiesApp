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
    // General Variables
    int viewWidth, viewHeight;
    
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UILabel *incorrectInfoLabel;
}

- (void) setup
{
    viewWidth  = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
}

- (void) viewDidLoad
{
    [self setup];
    
    // Username text field frame setup
    int textFieldWidth  = 250;
    int textFieldHeight = 40;
    int x               = (viewWidth / 2) - (textFieldWidth / 2);
    int y               = (viewHeight / 2) - (textFieldHeight / 2);
    y                   -= textFieldHeight;
    
    CGRect usernameFrame = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    y                    += (textFieldHeight + 10);
    CGRect passwordFrame = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    y                      += (textFieldHeight + 10);
    CGRect emptyFieldFrame = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    
    // Username Text Field Setup
    usernameTextField                   = [[UITextField alloc] initWithFrame:usernameFrame];
    usernameTextField.borderStyle       = UITextBorderStyleRoundedRect;
    usernameTextField.tintColor         = [UIColor blueColor];
    usernameTextField.backgroundColor   = [UIColor lightGrayColor];
    usernameTextField.placeholder       = @"Username";
    usernameTextField.returnKeyType     = UIReturnKeyNext;
    usernameTextField.delegate          = self;
    
    // Password Text Field Setup
    passwordTextField                   = [[UITextField alloc] initWithFrame:passwordFrame];
    passwordTextField.borderStyle       = UITextBorderStyleRoundedRect;
    passwordTextField.tintColor         = [UIColor blueColor];
    passwordTextField.backgroundColor   = [UIColor lightGrayColor];
    passwordTextField.placeholder       = @"Password";
    passwordTextField.returnKeyType     = UIReturnKeyGo;
    passwordTextField.delegate          = self;
    passwordTextField.secureTextEntry   = YES;
    
    // Empty password/username Label Setup
    incorrectInfoLabel              = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    incorrectInfoLabel.hidden       = YES;
    incorrectInfoLabel.text         = @"Incorrect password or username";
    incorrectInfoLabel.textColor    = [UIColor redColor];
    
    
    [self.view addSubview:usernameTextField];
    [self.view addSubview:passwordTextField];
    [self.view addSubview:incorrectInfoLabel];
    
}

-(BOOL) logIn
{
    UserData *ud = [UserData globalUserData];
    
    // Check to see if username and password match
    //if ([usernameTextField.text isEqual:@""] || [passwordTextField.text isEqual:@""])
    if (0)
    {
        incorrectInfoLabel.hidden   = NO;
        return false;
    } else {
        incorrectInfoLabel.hidden   = YES;
        ud.username                 = usernameTextField.text;
        return true;
    }
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == usernameTextField) {
        [passwordTextField becomeFirstResponder];
        return NO;
    } else if (textField == passwordTextField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}



@end

//
//  LogInViewController.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/27/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "LogInViewController.h"
#import <UIKit/UIKit.h>


@interface LogInViewController ()


@end

@implementation LogInViewController
{
    // General Variables
    int viewWidth, viewHeight;
    
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UITextField *newPasswordTF;
    UILabel *incorrectInfoLabel;
    UILabel *uniqueUsernameLabel;
    UILabel *notFullLabel;
    UILabel *passwordNoMatchLabel;
    UILabel *passLength;
    UILabel *userCreated;
    UIButton *regist;
    
  
    AppDelegate *parentController;
    
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

    int x                   = (viewWidth / 2) - (textFieldWidth / 2);
    int y                   = (viewHeight / 2) - (textFieldHeight / 2);
    int logInWidth          = 100;
    int logX                = (viewWidth / 2) - (logInWidth / 2);
    CGRect logInFrame       = CGRectMake(logX, ((viewHeight / 3) * 2), logInWidth, 35);
    
    y                      -= textFieldHeight;
    CGRect usernameFrame    = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    y                      += (textFieldHeight + 10);
    CGRect passwordFrame    = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    y                      += (textFieldHeight + 10);
    CGRect newPasswordFrame = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    y                      += (textFieldHeight + 10);
    CGRect emptyFieldFrame  = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    
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
    
    //second password text field setup
    newPasswordTF                   = [[UITextField alloc] initWithFrame:newPasswordFrame];
    newPasswordTF.borderStyle       = UITextBorderStyleRoundedRect;
    newPasswordTF.tintColor         = [UIColor blueColor];
    newPasswordTF.backgroundColor   = [UIColor lightGrayColor];
    newPasswordTF.placeholder       = @"Retype Password";
    newPasswordTF.returnKeyType     = UIReturnKeyNext;
    newPasswordTF.delegate          = self;
    newPasswordTF.hidden            = YES;
    newPasswordTF.secureTextEntry   = YES;
    
    // Empty password/username Label Setup
    incorrectInfoLabel              = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    incorrectInfoLabel.hidden       = YES;
    incorrectInfoLabel.text         = @"Incorrect password or username";
    incorrectInfoLabel.textColor    = [UIColor redColor];
    
    //unique username label Setup
    uniqueUsernameLabel             = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    uniqueUsernameLabel.hidden      = YES;
    uniqueUsernameLabel.text        = @"Username is Taken";
    uniqueUsernameLabel.textColor   = [UIColor redColor];
    
    //empty password/username register Setup
    notFullLabel              = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    notFullLabel.hidden       = YES;
    notFullLabel.text         = @"All Fields Are Required";
    notFullLabel.textColor    = [UIColor redColor];
    
    //passwords don't equal set up
    passwordNoMatchLabel            = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    passwordNoMatchLabel.hidden     = YES;
    passwordNoMatchLabel.text       = @"Passwords Are Not Equal";
    passwordNoMatchLabel.textColor  = [UIColor redColor];
    
    //passwords length too short set up
    passLength              = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    passLength.hidden       = YES;
    passLength.text         = @"Passwords Must Be At Least 8 Characters Long";
    passLength.textColor    = [UIColor redColor];
    
    //unique username set up
    uniqueUsernameLabel             = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    uniqueUsernameLabel.hidden      = YES;
    uniqueUsernameLabel.text        = @"Username is already being used.";
    uniqueUsernameLabel.textColor   = [UIColor redColor];
    
    //unique username set up
    userCreated             = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    userCreated.hidden      = YES;
    userCreated.text        = @"New User Created.";
    userCreated.textColor   = [UIColor redColor];
    
    
    //registration button creation
    regist                    = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    regist.titleLabel.font    = [UIFont systemFontOfSize:25];
    regist.frame              = logInFrame;
    regist.hidden             = YES;
    [regist setTitle:@"Register" forState:UIControlStateNormal];
    [regist addTarget:self action:@selector(registerNow) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self.view addSubview:regist];
    [self.view addSubview:usernameTextField];
    [self.view addSubview:passwordTextField];
    [self.view addSubview:newPasswordTF];
    [self.view addSubview:incorrectInfoLabel];
    [self.view addSubview:uniqueUsernameLabel];
    [self.view addSubview:notFullLabel];
    [self.view addSubview:passwordNoMatchLabel];
    [self.view addSubview:passLength];
    [self.view addSubview:userCreated];
    
    
}

- (void) hasParent: (AppDelegate *) parent
{
    parentController = parent;
}

- (NSString *) interactWithDatabase: (NSString *) username with: (NSString *) password at:(NSString *)path
{
    NSString *response;
    NSString *myRequestString;
    if(password == nil)
    {
        // Create your request string with parameter name as defined in PHP file
        myRequestString = [NSString stringWithFormat:@"username=%@",username];
    }
    else
    {
        // Create your request string with parameter name as defined in PHP file
        myRequestString = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    }
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSString *url = [NSString stringWithFormat:@"http://humanitiesapp.atwebpages.com/%@", path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    return response;
}

-(BOOL) logIn
{
    UserData *ud = [UserData globalUserData];
    
    userCreated.hidden = YES;
    
    NSString *response = [self interactWithDatabase:usernameTextField.text with:nil at:@"login.php"];
    
    // Check to see if username and password match
    //if ([usernameTextField.text isEqual:@""] || [passwordTextField.text isEqual:@""])
    if (!([passwordTextField.text isEqual:response]))
    {

        incorrectInfoLabel.hidden   = NO;
        usernameTextField.text      = nil;
        passwordTextField.text      = nil;

        return false;
    } else {
        incorrectInfoLabel.hidden   = YES;
        ud.username                 = usernameTextField.text;
        return true;
    }
    
}

//FIX THIS
-(BOOL) registerNow
{
    int length              = 8;
    newPasswordTF.hidden    = NO;
    regist.hidden           = NO;
    
    NSString *responseS = [self interactWithDatabase:usernameTextField.text with:passwordTextField.text at:@"checkuser.php"];
    
    
    BOOL used = NO;
    
    if ([responseS isEqualToString:@"YES"])
        used = YES;
    
    if([usernameTextField.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""] || [newPasswordTF.text isEqualToString:@""])
    {
        uniqueUsernameLabel.hidden    = YES;
        notFullLabel.hidden           = NO;
        passwordNoMatchLabel.hidden   = YES;
        passLength.hidden             = YES;
        userCreated.hidden            = YES;
    }
    else if(used)
    {
        uniqueUsernameLabel.hidden    = NO;
        notFullLabel.hidden           = YES;
        passwordNoMatchLabel.hidden   = YES;
        passLength.hidden             = YES;
        userCreated.hidden            = YES;
    }
    else if(![passwordTextField.text isEqual:newPasswordTF.text])
    {
        uniqueUsernameLabel.hidden    = YES;
        notFullLabel.hidden           = YES;
        passwordNoMatchLabel.hidden   = NO;
        passLength.hidden             = YES;
        userCreated.hidden            = YES;
        
    }
    else if(passwordTextField.text.length < length)
    {
        uniqueUsernameLabel.hidden      = YES;
        notFullLabel.hidden             = YES;
        passwordNoMatchLabel.hidden     = YES;
        passLength.hidden               = NO;
        userCreated.hidden              = YES;
    }
    else
    {
        
        uniqueUsernameLabel.hidden            = YES;
        notFullLabel.hidden                   = YES;
        passwordNoMatchLabel.hidden           = YES;
        newPasswordTF.hidden                  = YES;
        regist.hidden                         = YES;
        userCreated.hidden                    = NO;
        usernameTextField.text                = nil;
        passwordTextField.text                = nil;
        newPasswordTF.text                    = nil;
        parentController.logInButton.hidden   = NO;
        parentController.regButton.hidden     = NO;
    }
    
    usernameTextField.text = nil;
    passwordTextField.text = nil;
    
    return false;
    
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

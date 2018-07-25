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

//@property (nonatomic, strong) DBManager *dbManager;

//@property (nonatomic, strong) NSArray *arrUserInfo;

//-(void)loadData;

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
    UIButton *regist;
    
  
    
    
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
    int logInWidth = 100;
    int logX = (viewWidth / 2) - (logInWidth / 2);
    CGRect logInFrame = CGRectMake(logX, ((viewHeight / 3) * 2), logInWidth, 35);
    
    y -= textFieldHeight;
    
    CGRect usernameFrame = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    y += (textFieldHeight + 10);
    CGRect passwordFrame = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    y+= (textFieldHeight + 10);
    CGRect newPasswordFrame = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    y += (textFieldHeight + 10);
    CGRect emptyFieldFrame = CGRectMake(x, y, textFieldWidth, textFieldHeight);
    
    
    // Username Text Field Setup
    usernameTextField = [[UITextField alloc] initWithFrame:usernameFrame];
    usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    usernameTextField.tintColor = [UIColor blueColor];
    usernameTextField.backgroundColor = [UIColor lightGrayColor];
    usernameTextField.placeholder = @"Username";
    usernameTextField.returnKeyType = UIReturnKeyNext;
    usernameTextField.delegate = self;
    
    // Password Text Field Setup
    passwordTextField = [[UITextField alloc] initWithFrame:passwordFrame];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.tintColor = [UIColor blueColor];
    passwordTextField.backgroundColor = [UIColor lightGrayColor];
    passwordTextField.placeholder = @"Password";
    passwordTextField.returnKeyType = UIReturnKeyGo;
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    
    //second password text field setup
    newPasswordTF = [[UITextField alloc] initWithFrame:newPasswordFrame];
    newPasswordTF.borderStyle = UITextBorderStyleRoundedRect;
    newPasswordTF.tintColor = [UIColor blueColor];
    newPasswordTF.backgroundColor = [UIColor lightGrayColor];
    newPasswordTF.placeholder = @"Retype Password";
    newPasswordTF.returnKeyType = UIReturnKeyNext;
    newPasswordTF.delegate = self;
    newPasswordTF.hidden = YES;
    newPasswordTF.secureTextEntry = YES;
    
    // Empty password/username Label Setup
    incorrectInfoLabel = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    incorrectInfoLabel.hidden = YES;
    incorrectInfoLabel.text = @"Incorrect password or username";
    incorrectInfoLabel.textColor = [UIColor redColor];
    
    //unique username label Setup
    uniqueUsernameLabel = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    uniqueUsernameLabel.hidden = YES;
    uniqueUsernameLabel.text = @"Username is Taken";
    uniqueUsernameLabel.textColor = [UIColor redColor];
    
    //empty password/username register Setup
    notFullLabel = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    notFullLabel.hidden = YES;
    notFullLabel.text = @"All Fields Are Required";
    notFullLabel.textColor = [UIColor redColor];
    
    //passwords don't equal set up
    passwordNoMatchLabel = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    passwordNoMatchLabel.hidden = YES;
    passwordNoMatchLabel.text = @"Passwords Are Not Equal";
    passwordNoMatchLabel.textColor = [UIColor redColor];
    
    //passwords length too short set up
    passLength = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    passLength.hidden = YES;
    passLength.text = @"Passwords Must Be At Least 8 Characters Long";
    passLength.textColor = [UIColor redColor];
    
    //unique username set up
    uniqueUsernameLabel = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    uniqueUsernameLabel.hidden = YES;
    uniqueUsernameLabel.text = @"Username is already being used.";
    uniqueUsernameLabel.textColor = [UIColor redColor];
    
    
    //registration button creation
    regist = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [regist setTitle:@"Register" forState:UIControlStateNormal];
    regist.titleLabel.font = [UIFont systemFontOfSize:25];
    regist.frame = logInFrame;
    [regist addTarget:self action:@selector(registerNow) forControlEvents:UIControlEventTouchUpInside];
    regist.hidden = YES;
    
    
    
    [self.view addSubview:regist];
    [self.view addSubview:usernameTextField];
    [self.view addSubview:passwordTextField];
    [self.view addSubview:newPasswordTF];
    [self.view addSubview:incorrectInfoLabel];
    [self.view addSubview:uniqueUsernameLabel];
    [self.view addSubview:notFullLabel];
    [self.view addSubview:passwordNoMatchLabel];
    [self.view addSubview:passLength];
    
    //self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"appDB.sql"];
    
}

-(BOOL) logIn
{
    UserData *ud = [UserData globalUserData];
    
    // Create your request string with parameter name as defined in PHP file
    NSString *myRequestString = [NSString stringWithFormat:@"username=%@",usernameTextField.text];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://humanitiesapp.atwebpages.com/login.php"]];
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    
    // Check to see if username and password match
    //if ([usernameTextField.text isEqual:@""] || [passwordTextField.text isEqual:@""])
    if (!([passwordTextField.text isEqual:response]))
    {
        incorrectInfoLabel.hidden = NO;
        usernameTextField.text = nil;
        passwordTextField.text = nil;
        return false;
    } else {
        incorrectInfoLabel.hidden = YES;
        ud.username = usernameTextField.text;
        return true;
    }
    
}
/*
-(BOOL) createRegistration
{
    newPasswordTF.hidden = NO;
    regist.hidden = NO;
    finished = false;
    while(true)
    {
        if(finished)
        {
            break;
        }
        usleep(10000);
    }
    
    return true;
}
 */
/*
-(NSString) accessDatabase: (NSString *) username
{
    
}
 */

//FIX THIS
-(BOOL) registerNow
{
    int length = 8;
    newPasswordTF.hidden = NO;
    regist.hidden = NO;
    
    NSString *RequestString = [NSString stringWithFormat:@"username=%@&password=%@",usernameTextField.text,passwordTextField.text];
    
    // Create Data from request
    NSData *RequestData = [NSData dataWithBytes: [RequestString UTF8String] length: [RequestString length]];
    NSMutableURLRequest *requestS = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://humanitiesapp.atwebpages.com/checkuser.php"]];
    // set Request Type
    [requestS setHTTPMethod: @"POST"];
    // Set content-type
    [requestS setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [requestS setHTTPBody: RequestData];
    // Now send a request and get Response
    NSData *returnD = [NSURLConnection sendSynchronousRequest: requestS returningResponse: nil error: nil];
    // Log Response
    NSString *responseS = [[NSString alloc] initWithBytes:[returnD bytes] length:[returnD length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseS);
    
    BOOL used = NO;
    
    if ([responseS isEqualToString:@"YES"])
        used = YES;
    
    if([usernameTextField.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""] || [newPasswordTF.text isEqualToString:@""])
    {
        uniqueUsernameLabel.hidden = YES;
        notFullLabel.hidden = NO;
        passwordNoMatchLabel.hidden = YES;
        passLength.hidden = YES;
    }
    else if(used)
    {
        uniqueUsernameLabel.hidden = NO;
        notFullLabel.hidden = YES;
        passwordNoMatchLabel.hidden = YES;
        passLength.hidden = YES;
    }
    else if(![passwordTextField.text isEqual:newPasswordTF.text])
    {
        uniqueUsernameLabel.hidden = YES;
        notFullLabel.hidden = YES;
        passwordNoMatchLabel.hidden = NO;
            passLength.hidden = YES;
        
    }
    else if(passwordTextField.text.length < length)
    {
        uniqueUsernameLabel.hidden = YES;
        notFullLabel.hidden = YES;
        passwordNoMatchLabel.hidden = YES;
        passLength.hidden = NO;
    }
    else
    {
        
        // Create your request string with parameter name as defined in PHP file
        NSString *myRequestString = [NSString stringWithFormat:@"username=%@&password=%@",usernameTextField.text,passwordTextField.text];
        
        // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://humanitiesapp.atwebpages.com/register.php"]];
        // set Request Type
        [request setHTTPMethod: @"POST"];
        // Set content-type
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        // Set Request Body
        [request setHTTPBody: myRequestData];
        // Now send a request and get Response
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
        // Log Response
        NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        
        uniqueUsernameLabel.hidden = YES;
        notFullLabel.hidden = YES;
        passwordNoMatchLabel.hidden = YES;
        newPasswordTF.hidden = YES;
        regist.hidden = YES;
    }
    
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

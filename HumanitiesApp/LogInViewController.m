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

-(void) hideLabels;

@end

@implementation LogInViewController
{
    // General Variables
    int view_width, view_height;
    
    UITextField *username_TF;
    UITextField *password_TF;
    UITextField *create_username_TF;
    UITextField *create_password_TF;
    UITextField *verify_password_TF;
    UILabel *incorrect_info_LBL;
    UILabel *unique_username_LBL;
    UILabel *missing_field_LBL;
    UILabel *pw_no_match_LBL;
    UILabel *pw_length_LBL;
    UILabel *user_created_LBL;
    UIButton *register_button;
    
    
    AppDelegate *parent_controller;
    
}

- (void) viewDidLoad
{
    view_width  = self.view.frame.size.width;
    view_height = self.view.frame.size.height;
    
    CGRect logInFrame       = CGRectMake((view_width / 2) - 50, ((view_height / 3) * 2), 100, 35);
    CGRect usernameFrame    = CGRectMake((view_width / 2) - 125, (view_height / 2) - 60, 250, 40);
    CGRect passwordFrame    = CGRectMake((view_width / 2) - 125, (view_height / 2) - 10, 250, 40);
    CGRect newPasswordFrame = CGRectMake((view_width / 2) - 125, (view_height / 2) + 40, 250, 40);
    CGRect emptyFieldFrame  = CGRectMake((view_width / 2) - 125, (view_height / 2) + 90, 250, 40);
    
    
    // Username Text Field Setup
    username_TF                   = [[UITextField alloc] initWithFrame:usernameFrame];
    username_TF.borderStyle       = UITextBorderStyleRoundedRect;
    username_TF.tintColor         = [UIColor blueColor];
    username_TF.backgroundColor   = [UIColor lightGrayColor];
    username_TF.placeholder       = @"Username";
    username_TF.returnKeyType     = UIReturnKeyNext;
    username_TF.delegate          = self;
    
    // Password Text Field Setup
    password_TF                   = [[UITextField alloc] initWithFrame:passwordFrame];
    password_TF.borderStyle       = UITextBorderStyleRoundedRect;
    password_TF.tintColor         = [UIColor blueColor];
    password_TF.backgroundColor   = [UIColor lightGrayColor];
    password_TF.placeholder       = @"Password";
    password_TF.returnKeyType     = UIReturnKeyGo;
    password_TF.delegate          = self;
    password_TF.secureTextEntry   = YES;
    
    // Username Creation Text Field Setup
    create_username_TF                    = [[UITextField alloc] initWithFrame:usernameFrame];
    create_username_TF.borderStyle        = UITextBorderStyleRoundedRect;
    create_username_TF.tintColor          = [UIColor blueColor];
    create_username_TF.backgroundColor    = [UIColor lightGrayColor];
    create_username_TF.placeholder        = @"Create Username";
    create_username_TF.returnKeyType      = UIReturnKeyNext;
    create_username_TF.delegate           = self;
    create_username_TF.hidden             = YES;
    
    // Password Creation Text Field Setup
    create_password_TF                       = [[UITextField alloc] initWithFrame:passwordFrame];
    create_password_TF.borderStyle           = UITextBorderStyleRoundedRect;
    create_password_TF.tintColor             = [UIColor blueColor];
    create_password_TF.backgroundColor       = [UIColor lightGrayColor];
    create_password_TF.placeholder           = @"Create Password";
    create_password_TF.returnKeyType         = UIReturnKeyNext;
    create_password_TF.hidden                = YES;
    create_password_TF.delegate              = self;
    create_password_TF.secureTextEntry       = YES;
    
    //second password text field setup
    verify_password_TF                   = [[UITextField alloc] initWithFrame:newPasswordFrame];
    verify_password_TF.borderStyle       = UITextBorderStyleRoundedRect;
    verify_password_TF.tintColor         = [UIColor blueColor];
    verify_password_TF.backgroundColor   = [UIColor lightGrayColor];
    verify_password_TF.placeholder       = @"Retype Password";
    verify_password_TF.returnKeyType     = UIReturnKeyGo;
    verify_password_TF.delegate          = self;
    verify_password_TF.hidden            = YES;
    verify_password_TF.secureTextEntry   = YES;
    
    // Empty password/username Label Setup
    incorrect_info_LBL              = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    incorrect_info_LBL.hidden       = YES;
    incorrect_info_LBL.text         = @"Incorrect password or username";
    incorrect_info_LBL.textColor    = [UIColor redColor];
    
    //unique username label Setup
    unique_username_LBL             = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    unique_username_LBL.hidden      = YES;
    unique_username_LBL.text        = @"Username is Taken";
    unique_username_LBL.textColor   = [UIColor redColor];
    
    //empty password/username register Setup
    missing_field_LBL              = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    missing_field_LBL.hidden       = YES;
    missing_field_LBL.text         = @"All Fields Are Required";
    missing_field_LBL.textColor    = [UIColor redColor];
    
    //passwords don't equal set up
    pw_no_match_LBL            = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    pw_no_match_LBL.hidden     = YES;
    pw_no_match_LBL.text       = @"Passwords Are Not Equal";
    pw_no_match_LBL.textColor  = [UIColor redColor];
    
    //passwords length too short set up
    pw_length_LBL              = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    pw_length_LBL.hidden       = YES;
    pw_length_LBL.text         = @"Passwords Must Be At Least 8 Characters Long";
    pw_length_LBL.textColor    = [UIColor redColor];
    
    //unique username set up
    unique_username_LBL             = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    unique_username_LBL.hidden      = YES;
    unique_username_LBL.text        = @"Username is already being used.";
    unique_username_LBL.textColor   = [UIColor redColor];
    
    //unique username set up
    user_created_LBL             = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    user_created_LBL.hidden      = YES;
    user_created_LBL.text        = @"New User Created.";
    user_created_LBL.textColor   = [UIColor redColor];
    
    
    //registration button creation
    register_button                    = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    register_button.titleLabel.font    = [UIFont systemFontOfSize:25];
    register_button.frame              = logInFrame;
    register_button.hidden             = YES;
    [register_button setTitle:@"Register" forState:UIControlStateNormal];
    [register_button addTarget:self action:@selector(enterRegistrationInfo) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self.view addSubview:register_button];
    [self.view addSubview:username_TF];
    [self.view addSubview:password_TF];
    [self.view addSubview:create_username_TF];
    [self.view addSubview:create_password_TF];
    [self.view addSubview:verify_password_TF];
    [self.view addSubview:incorrect_info_LBL];
    [self.view addSubview:unique_username_LBL];
    [self.view addSubview:missing_field_LBL];
    [self.view addSubview:pw_no_match_LBL];
    [self.view addSubview:pw_length_LBL];
    [self.view addSubview:user_created_LBL];
    
    
}

-(void) hideLabels
{
    incorrect_info_LBL.hidden = YES;
    unique_username_LBL.hidden = YES;
    missing_field_LBL.hidden = YES;
    pw_no_match_LBL.hidden = YES;
    pw_length_LBL.hidden = YES;
    unique_username_LBL.hidden = YES;
    user_created_LBL.hidden = YES;
}

- (void) hasParent: (AppDelegate *) parent
{
    parent_controller = parent;
}

- (NSString *) interactWithDatabase: (NSString *) username with: (NSString *) password at:(NSString *)path
{
    NSString *response;
    NSString *request_string;
    if(password == nil) {
        // Create your request string with parameter name as defined in PHP file
        request_string = [NSString stringWithFormat:@"username=%@",username];
    } else {
        // Create your request string with parameter name as defined in PHP file
        request_string = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    }
    
    // Create Data from request
    
    NSData *request_data = [NSData dataWithBytes: [request_string UTF8String] length: [request_string length]];
    NSString *url = [NSString stringWithFormat:@"http://humanitiesapp.atwebpages.com/%@", path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
    
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: request_data];
    // Now send a request and get Response
    NSData *return_data = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    response = [[NSString alloc] initWithBytes:[return_data bytes] length:[return_data length] encoding:NSUTF8StringEncoding];
    return response;
}

-(NSMutableArray *) toArray:(NSString *)data
{
    NSArray *items = [data componentsSeparatedByString:@" "];
    NSMutableArray* array_of_numbers = [NSMutableArray arrayWithCapacity:items.count];
    for (NSString* string in items) {
        [array_of_numbers addObject:[NSDecimalNumber decimalNumberWithString:string]];
    }
    
    return array_of_numbers;
}

-(BOOL) enterLogInCredentials
{
    UserData *ud = [UserData sharedMyProjects];
    user_created_LBL.hidden = YES;
    
    NSString *response = [self interactWithDatabase:username_TF.text with:nil at:@"login.php"];
    
    // Check to see if username and password match
    if (!([password_TF.text isEqual:response])) {
        [self hideLabels];
        incorrect_info_LBL.hidden = NO;
        username_TF.text = nil;
        password_TF.text = nil;
        return false;
    } else {
        NSString *account_ID = [self interactWithDatabase:username_TF.text with:password_TF.text at:@"setAccId.php"];
        [self hideLabels];
        ud.username = username_TF.text;
        ud.account_ID = account_ID;
        NSString *followers = [self interactWithDatabase:ud.account_ID with: nil at:@"getFollowing.php"];
        ud.followers = [self toArray:followers];
        NSString *projIds = [self interactWithDatabase:ud.account_ID with: nil at:@"allProj.php"];
        ud.project_IDs = [self toArray:projIds];
        
        
        return true;
    }
    
}


-(BOOL) enterRegistrationInfo
{
    username_TF.hidden          = YES;
    password_TF.hidden          = YES;
    create_password_TF.hidden   = NO;
    verify_password_TF.hidden   = NO;
    register_button.hidden      = NO;
    create_username_TF.hidden   = NO;
    
    
    NSString *response          = [self interactWithDatabase:create_username_TF.text with:create_password_TF.text at:@"checkuser.php"];
    
    BOOL used = NO;
    
    if ([response isEqualToString:@"YES"]) used = YES;
    
    
    
    if([create_username_TF.text isEqualToString:@""] || [create_password_TF.text isEqualToString:@""] || [verify_password_TF.text isEqualToString:@""])
    {
        [self hideLabels];
        missing_field_LBL.hidden    = NO;
    } else if(used) {
        [self hideLabels];
        unique_username_LBL.hidden  = NO;
    } else if(![create_password_TF.text isEqual:verify_password_TF.text]) {
        [self hideLabels];
        pw_no_match_LBL.hidden      = NO;
    } else if(create_password_TF.text.length < 8) {
        [self hideLabels];
        pw_length_LBL.hidden        = NO;
    } else {
        
        
        NSString *respons     = [self interactWithDatabase:create_username_TF.text with:create_password_TF.text at:@"register.php"];
        NSLog(@"%@",respons);
        [self hideLabels];
        
        create_username_TF.hidden       = YES;
        create_password_TF.hidden       = YES;
        verify_password_TF.hidden       = YES;
        register_button.hidden          = YES;
        
        username_TF.hidden              = NO;
        password_TF.hidden              = NO;
        user_created_LBL.hidden         = NO;
        
        username_TF.text                = nil;
        create_username_TF.text         = nil;
        create_password_TF.text         = nil;
        verify_password_TF.text         = nil;
        
        parent_controller.log_in_button.hidden      = NO;
        parent_controller.create_user_button.hidden = NO;
    }
    
    username_TF.text                  = nil;
    password_TF.text                  = nil;
    
    return false;
    
}

/*
 Parameter: textField, can be compared with a global variable to confirm which text field should return
 Return Value: Bool, YES if the text field should return
 */
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == username_TF) {
        
        [password_TF becomeFirstResponder];
        return NO;
        
    } else if (textField == password_TF) {
        
        [textField resignFirstResponder];
        [parent_controller logIn];
        
    } else if (textField == create_username_TF) {
        
        [create_password_TF becomeFirstResponder];
        return NO;
        
    } else if (textField == create_password_TF) {
        
        [verify_password_TF becomeFirstResponder];
        return NO;
        
    } else if (textField == verify_password_TF) {
        
        [textField resignFirstResponder];
        
    }
    
    return YES;
}



@end

//
//  ViewController.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/25/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController
{
    int view_width, view_height;
    
    // Scroll View Variable Declarations
    UIScrollView *following_projects_SV;
    UITextField *search_bar_TF;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // General Variable Initialization
    view_width          = self.view.frame.size.width;
    view_height         = self.view.frame.size.height;
    
    // Search Bar Text Field Setup
    search_bar_TF                   = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, (view_width - 20), 35)];
    search_bar_TF.borderStyle       = UITextBorderStyleRoundedRect;
    search_bar_TF.tintColor         = [UIColor blueColor];
    search_bar_TF.backgroundColor   = [UIColor lightGrayColor];
    search_bar_TF.placeholder       = @"Search...";
    search_bar_TF.returnKeyType     = UIReturnKeyGo;
    search_bar_TF.delegate          = self;
    
    
    // Project View Setup
    following_projects_SV                  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 85, view_width, view_height - 85)];
    following_projects_SV.backgroundColor  = [UIColor whiteColor];
    following_projects_SV.contentSize      = CGSizeMake(view_width, 4000);
    
    
    // Load user projects
    UserData *ud        = [UserData sharedMyProjects];
    int project_count = (int) ud.project_IDs.count - 1;
    
    for (int i = 0; i < project_count; i++) {
        ProjectData *user_project     = [[ProjectData alloc] init];
        user_project.projectName      = [self interactWithDatabase:ud.project_IDs[i] with:nil at:@"getName.php"];
        user_project.projectId          = ud.project_IDs[i];
        
        [ud.user_projects addObject:user_project];
    }
    
    
    self.view.backgroundColor = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    // Adding sub views
    [self.view addSubview:following_projects_SV];
    [self.view addSubview:search_bar_TF];
    
    [self createFollowerPreviews];
}

- (NSString *) interactWithDatabase: (NSString *) username with: (NSString *) password at:(NSString *)path
{
    NSString *response;
    NSString *request_string;
    if(password == nil)
    {
        // Create your request string with parameter name as defined in PHP file
        request_string = [NSString stringWithFormat:@"username=%@",username];
    }
    else
    {
        // Create your request string with parameter name as defined in PHP file
        request_string = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    }
    // Create Data from request
    NSData *request_data            = [NSData dataWithBytes: [request_string UTF8String] length: [request_string length]];
    NSString *url                   = [NSString stringWithFormat:@"http://humanitiesapp.atwebpages.com/%@", path];
    NSMutableURLRequest *request    = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // Set Request Body
    [request setHTTPBody: request_data];
    
    // Now send a request and get Response
    NSData *return_data  = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    
    // Log Response
    response            = [[NSString alloc] initWithBytes:[return_data bytes] length:[return_data length] encoding:NSUTF8StringEncoding];
    
    return response;
}


/*
 Parameter: textField, can be compared with a global variable to confirm which text field should return
 Return Value: Bool, YES if the text field should return
 */
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == search_bar_TF) [textField resignFirstResponder];
    
    return YES;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *) toArray:(NSString *)data
{
    NSArray *items                      = [data componentsSeparatedByString:@" "];
    NSMutableArray* array_of_numbers    = [NSMutableArray arrayWithCapacity:items.count];
    for (NSString* string in items) {
        [array_of_numbers addObject:[NSDecimalNumber decimalNumberWithString:string]];
    }
    
    return array_of_numbers;
}

/*
 This function creates the previews seen on the home page of the application. These previews present a
 preview image for the project. Previews can be tapped on to take the user to the project, where
 the files are held.
 */
- (void) createFollowerPreviews
{
    int i;

    UserData *ud                    = [UserData sharedMyProjects];
    NSString *follower_project_IDs  = @"";
    int follower_count              = (int) ud.followers.count - 1;
    
    for (i = 0; i <= follower_count; i++)
    {
        NSString *ids           = [self interactWithDatabase:ud.followers[i] with: nil at:@"followerProj.php"];
        follower_project_IDs    = [follower_project_IDs stringByAppendingString:ids];
    }
    
    ud.follower_project_IDs          = [self toArray:follower_project_IDs];
    int follower_project_count  = (int) ud.follower_project_IDs.count -1;
    
    for (int i = 0; i < follower_project_count; i++) {
        ProjectData *follower_project     = [[ProjectData alloc] init];
        follower_project.projectName      = [self interactWithDatabase:ud.follower_project_IDs[i] with:nil at:@"getName.php"];
        follower_project.projectId        = ud.follower_project_IDs[i];
        // Code to add files (another loop)
        [ud.follower_projects addObject:follower_project];
    }
    
    ProjectPreView *project_previews[follower_project_count+1];
    CGRect preview_frame[follower_project_count+1];
    
    int preview_initial_height  = 351;
    int preview_height          = 350;
    
    [self changeScrollHeight:(preview_initial_height * (follower_project_count+1))];
    
    if(follower_project_count == 0)
        follower_project_count--;

    for (i = follower_project_count-1; i >= 0; i--) {
        
        ProjectData *pd = (ProjectData *) ud.follower_projects[i];
        
        preview_frame[i]        = CGRectMake(0,  (preview_initial_height * i), view_width, preview_height);
        project_previews[i]     = [[ProjectPreView alloc] initWithFrame:preview_frame[i]];

        [project_previews[i] setProjectName:pd.projectName andID:pd.projectId withParentView:self];

        [following_projects_SV addSubview: project_previews[i]];

        project_previews[i].inEditingMode = false;
        
    }
}

/*
 This function is used to change the height of the scroll view. This is used everytime a new project is added. This allows the program to change the scroll height dynamically.
 INPUT: height, the new length that the scroll view will be set to
 */
- (void) changeScrollHeight:(int)height
{
    following_projects_SV.contentSize = CGSizeMake(view_width, height);
}

/*
 This is where the tab bar item (bottom of the screen) is created. It will use a picture, and wants a name for the item
 */
- (UITabBarItem *)tabBarItem
{
    UITabBarItem *item;
    
    UIImage *homeImage  = [UIImage imageNamed:@"Home.png"];
    UIImage *scaled     = [UIImage imageWithCGImage:[homeImage CGImage] scale:(homeImage.scale * 45) orientation:UIImageOrientationUp];
    
    
    item                = [[UITabBarItem alloc] initWithTitle:@"Home" image:scaled tag:0];
    
    
    return item;
}
 

@end

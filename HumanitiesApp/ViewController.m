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
    int viewWidth, viewHeight;
    
    // Scroll View Variable Declarations
    UIScrollView *myProjectsView;
    int scrollHeightInitial, scrollHeight;
    int scrollWidthInitial, scrollWidth;
    CGRect scrollViewFrame;
    
    // Preview Variable Declarations
    int pvWidthInitial, pvWidth;
    int pvHeightInitial, pvHeight;
    
    UITextField *searchBar;
    CGRect searchFrame;
    int searchHeightInitial, searchHeight;
    
}

- (void) setup
{
    // General Variable Initialization
    viewWidth           = self.view.frame.size.width;
    viewHeight          = self.view.frame.size.height;
    
    // Scroll View Variable initialization
    scrollHeightInitial = 85;
    scrollWidthInitial  = 0;
    
    scrollWidth         = viewWidth - (2 * scrollWidthInitial);
    scrollHeight        = viewHeight - scrollHeightInitial;
    
    scrollViewFrame     = CGRectMake(scrollWidthInitial, scrollHeightInitial, scrollWidth, scrollHeight);
    
    
    // Search Bar Text Field Variable Initialization
    searchHeightInitial = 40;
    searchHeight        = scrollHeightInitial - (searchHeightInitial + 10);
    
    searchFrame         = CGRectMake(10, searchHeightInitial, (viewWidth - 20), searchHeight);
    
    
    // Preview Variable initialization
    pvWidthInitial      = 0;
    pvHeightInitial     = 351;
    pvHeight            = 350;
    pvWidth             = viewWidth - pvWidthInitial;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Search Bar Text Field Setup
    searchBar                   = [[UITextField alloc] initWithFrame:searchFrame];
    searchBar.borderStyle       = UITextBorderStyleRoundedRect;
    searchBar.tintColor         = [UIColor blueColor];
    searchBar.backgroundColor   = [UIColor lightGrayColor];
    searchBar.placeholder       = @"Search...";
    searchBar.returnKeyType     = UIReturnKeyGo;
    searchBar.delegate          = self;
    
    
    // Project View Setup
    myProjectsView                  = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    myProjectsView.backgroundColor  = [UIColor whiteColor];
    myProjectsView.contentSize      = CGSizeMake(viewWidth, 4000);
    
    
    UserData *ud        = [UserData sharedMyProjects];
    int num_of_projects = (int) ud.projIds.count - 1;
    
    for (int i = 0; i < num_of_projects; i++) {
        ProjectData *newProject     = [[ProjectData alloc] init];
        newProject.projectName      = [self interactWithDatabase:ud.projIds[i] with:nil at:@"getName.php"];
        newProject.projectId = ud.projIds[i];
        // Code to add files (another loop)
        [ud.myProjects addObject:newProject];
    }
    
    
    self.view.backgroundColor       = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    // Adding sub views
    [self.view addSubview:myProjectsView];
    [self.view addSubview:searchBar];
    
    [self createPreView];
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
    NSData *myRequestData           = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSString *url                   = [NSString stringWithFormat:@"http://humanitiesapp.atwebpages.com/%@", path];
    NSMutableURLRequest *request    = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    // Now send a request and get Response
    NSData *returnData  = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    
    // Log Response
    response            = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    
    return response;
}


/*
 Parameter: textField, can be compared with a global variable to confirm which text field should return
 Return Value: Bool, YES if the text field should return
 */
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == searchBar) [textField resignFirstResponder];
    
    return YES;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *) toArray:(NSString *)data
{
    NSArray *items = [data componentsSeparatedByString:@" "];
    NSMutableArray* arrayOfNumbers = [NSMutableArray arrayWithCapacity:items.count];
    for (NSString* string in items) {
        [arrayOfNumbers addObject:[NSDecimalNumber decimalNumberWithString:string]];
    }
    
    return arrayOfNumbers;
}
 /*
 This function creates the previews seen on the home page of the application. These previews present a
 preview image for the project. Previews can be tapped on to take the user to the project, where
 the files are held.
 */
- (void) createPreView
{
    int i;
    int j;

    UserData *ud        = [UserData sharedMyProjects];
    NSString *folProjIds = @"";
    
    int num_of_projects = (int) ud.projIds.count - 1; // Subtract 1 because array contains a terminating element passed from database
     int num_of_fol = (int) ud.followers.count - 1;
    
    NSLog(@"followers: %lu", ud.followers.count-1);
    
    for (j = 0; j <= num_of_fol; j++)
    {
        NSString *ids = [self interactWithDatabase:ud.followers[j] with: nil at:@"followerProj.php"];
        folProjIds = [folProjIds stringByAppendingString:ids];
    }
    
    ud.followerProjIds = [self toArray:folProjIds];
    // Need to check number of projects, make sure not too many
    int num_of_fol_projects = (int) ud.followerProjIds.count -1;
    
    for (int i = 0; i <= num_of_fol_projects; i++) {
        ProjectData *newProject     = [[ProjectData alloc] init];
        newProject.projectName      = [self interactWithDatabase:ud.followerProjIds[i] with:nil at:@"getName.php"];
        newProject.projectId = ud.followerProjIds[i];
        // Code to add files (another loop)
        [ud.followerProjects addObject:newProject];
    }
    
    ProjectPreView *project_previews[num_of_fol_projects+1];
    CGRect preview_frame[num_of_fol_projects+1];
    
    if(num_of_fol_projects == 0)
        num_of_fol_projects--;
    
    for (i = num_of_fol_projects; i >= 0; i--) {
        
        ProjectData *pd = (ProjectData *) ud.followerProjects[i];
        
        preview_frame[i]        = CGRectMake(pvWidthInitial,  (pvHeightInitial * i), pvWidth, pvHeight);
        project_previews[i]     = [[ProjectPreView alloc] initWithFrame:preview_frame[i]];

        [project_previews[i] setProjectName:pd.projectName withParentView:self];

        [myProjectsView addSubview: project_previews[i]];

        project_previews[i].inEditingMode = false;
        
    }
}

/*
 This function is used to change the height of the scroll view. This is used everytime a new project is added. This allows the program to change the scroll height dynamically.
 INPUT: height, the new length that the scroll view will be set to
 */
- (void) changeScrollHeight:(int)height
{
    myProjectsView.contentSize = CGSizeMake(viewWidth, height);
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

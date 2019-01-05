//
//  PersonalPageViewController.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/28/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "PersonalPageViewController.h"

@interface PersonalPageViewController ()


@end

@implementation PersonalPageViewController
{
    int view_width, view_height;
    
    // Scroll View Variable Declarations
    UIScrollView *user_projects_SV;
    
    // Username Label Variable Declarations
    UILabel *username_LBL;
    int username_LBL_width;
    int username_LBL_height;
    CGRect username_frame;
    
    // New Project Button Variable Declarations
    UIButton *create_project_button;
    
    // Project Editing View Variable Declarations
    ProjectView *project_view;
    ProjectPreView *previews[100]; //***
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    view_width           = self.view.frame.size.width;
    view_height          = self.view.frame.size.height;
    
    self.view.backgroundColor   = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    // Username Label setup
    username_LBL                = [[UILabel alloc] initWithFrame:CGRectMake((view_width / 2) - 50, 45, 100, 30)];
    UserData *ud                = [UserData sharedMyProjects];
    username_LBL.textAlignment  = NSTextAlignmentCenter;
    username_LBL.text           = ud.username; // This needs to retrieve username from UserData
    
    
    // Project View Setup
    user_projects_SV                  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 85, view_width, view_height - 85)];
    user_projects_SV.backgroundColor  = [UIColor whiteColor];
    user_projects_SV.contentSize      = CGSizeMake(view_width, view_height);
    
    
    // New Project Button Setup
    create_project_button        = [UIButton buttonWithType:UIButtonTypeContactAdd];
    create_project_button.frame  = CGRectMake(view_width - 45, 45, 30, 30);
    [create_project_button addTarget:self action:@selector(createNewProject) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Adding subviews
    [self.view addSubview:user_projects_SV];
    [self.view addSubview:username_LBL];
    [self.view addSubview:create_project_button];
    
    [self createPreviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createPreviews];
}
/*
 Allows scroll height in the personal page to be changed dynamically.
 */
- (void) changeScrollHeight:(int) height
{
    user_projects_SV.contentSize = CGSizeMake(view_width, (height + 40));
}

/*
 This function creates all previews for the personal page. These previews present a
 preview image for the project. Previews can be tapped on to take the user to the project, where
 the files are held.
 */
- (void) createPreviews
{
    
    for (UIView *view in user_projects_SV.subviews)
        if ([view isKindOfClass:[ProjectPreView class]]) [view removeFromSuperview];
    
    UserData *projects = [UserData sharedMyProjects];
    int preview_count  = (int) projects.user_projects.count;
    
    
    
    CGRect preview_frame[preview_count];
    int preview_initial_height  = 351;
    int preview_height          = 350;
    
    [self changeScrollHeight:(preview_initial_height * preview_count)];
    
    int i;
    
    for (i = 0; i < preview_count; i++) {
        
        ProjectData *pd = (ProjectData *) projects.user_projects[i];
        
        
        
        preview_frame[i]         = CGRectMake(0,  (preview_initial_height * i), view_width, preview_height);
        previews[i]     = [[ProjectPreView alloc] initWithFrame:preview_frame[i]];
        
        [previews[i] setProjectName:pd.projectName andID:nil withParentView:self];
        [user_projects_SV addSubview: previews[i]];
        
        previews[i].inEditingMode   = true;
        
    }
    
}

/*
 This function is called when a new project is going to be created. Called by the + button on the top right of the screen in the personal page.
 */
- (void) createNewProject
{
    
    UIViewController *current_top_VC    = [self currentTopViewController];
    project_view                        = [[ProjectView alloc] init];
    
    [current_top_VC presentViewController:project_view animated:YES completion:nil];
    [project_view enterNewProjectMode];
}


/*
 OUTPUT: Returns the current top view controller.
 This allows the program to present the editing view.
 */
- (UIViewController *) currentTopViewController
{
    UIViewController *top_VC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (top_VC.presentedViewController)
        top_VC = top_VC.presentedViewController;
    
    return top_VC;
}

/*
 This is where the tab bar item (bottom of the screen) is created. It will use a picture, and wants a name for the item
 */
- (UITabBarItem *)tabBarItem
{
    UITabBarItem *item;
    
    UIImage *projects_image  = [UIImage imageNamed:@"Files.png"];
    UIImage *scaled         = [UIImage imageWithCGImage:[projects_image CGImage] scale:(projects_image.scale * 15) orientation:UIImageOrientationUp];
    
    item                    = [[UITabBarItem alloc] initWithTitle:@"My Projects" image:scaled tag:2];
    
    
    return item;
}


@end

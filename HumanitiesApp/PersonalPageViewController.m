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
    int viewWidth, viewHeight;
    
    // Scroll View Variable Declarations
    UIScrollView *myProjectsView;
    int scrollHeightInitial, scrollHeight;
    int scrollWidthInitial, scrollWidth;
    
    // Preview Variable Declarations
    int pvWidthInitial, pvWidth;
    int pvHeightInitial, pvHeight;
    
    // Username Label Variable Declarations
    UILabel *usernameLabel;
    int labelWidthInitial, labelWidth;
    int labelHeightInitial, labelHeight;
    CGRect usernameFrame;
    
    // New Project Button Variable Declarations
    UIButton *newProjectButton;
    int buttonWidthInitial, buttonWidth;
    int buttonHeightInitial, buttonHeight;
    CGRect newProjectFrame;
    
    // Project Editing View Variable Declarations
    ProjectView *projectEditingView;
    ProjectPreView *previews[100]; //***
    
}

- (void) frameSetup
{
    // General Variables
    viewWidth           = self.view.frame.size.width;
    viewHeight          = self.view.frame.size.height;
    
    
    // Scroll View Variable initialization
    scrollHeightInitial = 85;
    scrollWidthInitial  = 0;
    scrollWidth         = viewWidth - (2 * scrollWidthInitial);
    scrollHeight        = viewHeight - scrollHeightInitial;
    
    
    // Preview Variable initialization
    pvWidthInitial      = 0;
    pvHeightInitial     = 351;
    pvHeight            = 350;
    pvWidth             = viewWidth - pvWidthInitial;
    
    
    // Username Label Variable initialization
    labelWidth          = 100;
    labelWidthInitial   = (viewWidth / 2) - (labelWidth / 2);
    
    labelHeight         = 30;
    labelHeightInitial  = 30 + (labelHeight / 2);
    
    usernameFrame       = CGRectMake(labelWidthInitial, labelHeightInitial, labelWidth, labelHeight);
    
    
    // New Project Button Variable Initialization
    buttonWidth         = 30;
    buttonWidthInitial  = viewWidth - (buttonWidth + 15);
    
    buttonHeight        = 30;
    buttonHeightInitial = 30 + (buttonHeight / 2);
    
    newProjectFrame     = CGRectMake(buttonWidthInitial, buttonHeightInitial, buttonWidth, buttonHeight);
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self frameSetup];
    
    self.view.backgroundColor   = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    // Username Label setup
    usernameLabel               = [[UILabel alloc] initWithFrame:usernameFrame];
    UserData *ud                = [UserData globalUserData];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    usernameLabel.text          = ud.username; // This needs to retrieve username from UserData
    
    
    // Project View Setup
    myProjectsView                  = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollWidthInitial, scrollHeightInitial, scrollWidth, scrollHeight)];
    myProjectsView.backgroundColor  = [UIColor whiteColor];
    myProjectsView.contentSize      = CGSizeMake(viewWidth, viewHeight);
    
    
    // New Project Button Setup
    newProjectButton        = [UIButton buttonWithType:UIButtonTypeContactAdd];
    newProjectButton.frame  = newProjectFrame;
    [newProjectButton addTarget:self action:@selector(createNewProject) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Adding subviews
    [self.view addSubview:myProjectsView];
    [self.view addSubview:usernameLabel];
    [self.view addSubview:newProjectButton];
    
    [self createPreviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createPreviews];
}

- (void) changeScrollHeight:(int)height
{
    myProjectsView.contentSize = CGSizeMake(viewWidth, (height + 40));
}

- (void) createPreviews
{
    
    for (UIView *view in myProjectsView.subviews)
        if ([view isKindOfClass:[ProjectPreView class]]) [view removeFromSuperview];
    
    UserData *projects   = [UserData sharedMyProjects];
    int numberOfPreviews = (int) projects.myProjects.count;
    
    
    
    CGRect rect[numberOfPreviews];
    
    [self changeScrollHeight:(pvHeightInitial * numberOfPreviews)];
    
    int i;
    
    for (i = 0; i < numberOfPreviews; i++) {
        
        ProjectData *pd = (ProjectData *) projects.myProjects[i];
        
        rect[i]         = CGRectMake(pvWidthInitial,  (pvHeightInitial * i), pvWidth, pvHeight);
        previews[i]     = [[ProjectPreView alloc] initWithFrame:rect[i]];
        
        [previews[i] setProjectName:pd.projectName withParentView:self];
        [myProjectsView addSubview: previews[i]];
        
        previews[i].inEditingMode   = true;
        
    }
    
}

- (void) createNewProject
{
    
    UIViewController *currentTopVC  = [self currentTopViewController];
    projectEditingView              = [[ProjectView alloc] init];
    
    [currentTopVC presentViewController:projectEditingView animated:YES completion:nil];
    [projectEditingView enterNewProjectMode];
}

- (UIViewController *) currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (topVC.presentedViewController)
        topVC = topVC.presentedViewController;
    
    return topVC;
}

- (UITabBarItem *)tabBarItem
{
    UITabBarItem *item;
    
    UIImage *projectsImage  = [UIImage imageNamed:@"Files.png"];
    UIImage *scaled         = [UIImage imageWithCGImage:[projectsImage CGImage] scale:(projectsImage.scale * 15) orientation:UIImageOrientationUp];
    
    item                    = [[UITabBarItem alloc] initWithTitle:@"My Projects" image:scaled tag:2];
    
    
    return item;
}


@end

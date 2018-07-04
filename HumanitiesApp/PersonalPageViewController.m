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
    
}

- (void) setup
{
    // General Variables
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    
    
    // Scroll View Variable initialization
    scrollHeightInitial = 85;
    scrollWidthInitial = 0;
    scrollWidth = viewWidth - (2 * scrollWidthInitial);
    scrollHeight = viewHeight - scrollHeightInitial;
    
    
    // Preview Variable initialization
    pvWidthInitial = 0;
    pvHeightInitial = 351;
    pvHeight = 350;
    pvWidth = viewWidth - pvWidthInitial;
    
    
    // Username Label Variable initialization
    labelWidth = 100;
    labelWidthInitial = (viewWidth / 2) - (labelWidth / 2);
    
    labelHeight = 30;
    labelHeightInitial = 30 + (labelHeight / 2);
    
    usernameFrame = CGRectMake(labelWidthInitial, labelHeightInitial, labelWidth, labelHeight);
    
    
    // New Project Button Variable Initialization
    buttonWidth = 30;
    buttonWidthInitial = viewWidth - (buttonWidth + 15);
    
    buttonHeight = 30;
    buttonHeightInitial = 30 + (buttonHeight / 2);
    
    newProjectFrame = CGRectMake(buttonWidthInitial, buttonHeightInitial, buttonWidth, buttonHeight);
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    
    self.view.backgroundColor = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    // Username Label setup
    usernameLabel = [[UILabel alloc] initWithFrame:usernameFrame];
    UserData *ud = [UserData globalUserData];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    usernameLabel.text = ud.username; // This needs to retrieve username from UserData
    
    
    // Project View Setup
    myProjectsView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollWidthInitial, scrollHeightInitial, scrollWidth, scrollHeight)];
    myProjectsView.backgroundColor = [UIColor blackColor];
    myProjectsView.contentSize = CGSizeMake(viewWidth, 4000);
    
    
    // New Project Button Setup
    newProjectButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    newProjectButton.frame = newProjectFrame;
    [newProjectButton addTarget:self action:@selector(createNewProject) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Adding subviews
    [self.view addSubview:myProjectsView];
    [self.view addSubview:usernameLabel];
    [self.view addSubview:newProjectButton];
    
    
    
    
    
    [self createPreView:3];
    
    
}

- (void) createPreView:(int) it
{
    int i;
    
    PreView *pv[it];
    CGRect rect[it];
    NSArray *names = [[NSMutableArray alloc] initWithObjects:@"Mike", @"Ben", @"Sammy", nil];
    // Need to make a class that contains data for a personal project
    // Have a vector of projects
    // Pull data from vector to display on the screen
    
    for (i = 0; i < it; i++)
    {
        rect[i] = CGRectMake(pvWidthInitial,  (pvHeightInitial * i), pvWidth, pvHeight);
        pv[i] = [[PreView alloc] initWithFrame:rect[i]];
        
        [pv[i] setUsername:names[i]];
        [myProjectsView addSubview: pv[i]];
    }
}

- (void) createNewProject
{
    
    UIViewController *currentTopVC = [self currentTopViewController];
    
    
    
    projectEditingView = [[ProjectView alloc] init];
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
    
    UIImage *projectsImage = [UIImage imageNamed:@"Files.png"];
    UIImage *scaled = [UIImage imageWithCGImage:[projectsImage CGImage] scale:(projectsImage.scale * 15) orientation:UIImageOrientationUp];
    
    item = [[UITabBarItem alloc] initWithTitle:@"My Projects" image:scaled tag:2];
    
    
    return item;
}


@end

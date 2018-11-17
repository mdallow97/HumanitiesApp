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
    
    UserData *ud = [UserData globalUserData];
    int num_of_projects = (sizeof(ud.projIds) / sizeof(ud.projIds[0])) - 1;
    
    for (int i = 0; i < num_of_projects; i++) {
        //[[ud.myProjects objectAtIndex:i] projectName] = 
    }
    
    
    self.view.backgroundColor       = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    // Adding sub views
    [self.view addSubview:myProjectsView];
    [self.view addSubview:searchBar];
    
    [self createPreView];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == searchBar) [textField resignFirstResponder];
    
    return YES;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createPreView
{
    int i;

    UserData *ud = [UserData globalUserData];
    int num_of_projects = (sizeof(ud.projIds) / sizeof(ud.projIds[0])) - 1;
    
    // Need to check number of projects, make sure not too many
    
    ProjectPreView *project_previews[num_of_projects];
    CGRect preview_frame[num_of_projects];
    NSArray *names; // *** names will get pulled from database
    
    for (i = num_of_projects - 1; i >= 0; i--) {
        
        preview_frame[i] = CGRectMake(pvWidthInitial,  (pvHeightInitial * i), pvWidth, pvHeight);
        project_previews[i]   = [[ProjectPreView alloc] initWithFrame:preview_frame[i]];

        [project_previews[i] setProjectName:names[i] withParentView:self];

        [myProjectsView addSubview: project_previews[i]];

        project_previews[i].inEditingMode = false;
    }
}

- (void) changeScrollHeight:(int)height
{
    myProjectsView.contentSize = CGSizeMake(viewWidth, height);
}

- (UITabBarItem *)tabBarItem
{
    UITabBarItem *item;
    
    UIImage *homeImage  = [UIImage imageNamed:@"Home.png"];
    UIImage *scaled     = [UIImage imageWithCGImage:[homeImage CGImage] scale:(homeImage.scale * 45) orientation:UIImageOrientationUp];
    
    
    item                = [[UITabBarItem alloc] initWithTitle:@"Home" image:scaled tag:0];
    
    
    return item;
}
 

@end

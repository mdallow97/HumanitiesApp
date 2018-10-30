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
    
    self.view.backgroundColor       = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    // Adding sub views
    [self.view addSubview:myProjectsView];
    [self.view addSubview:searchBar];
    
    [self createPreView:3];
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

- (void) createPreView:(int) it
{
    int i;
    
    ProjectPreView *pv[it];
    CGRect rect[it];
    NSArray *names = [[NSMutableArray alloc] initWithObjects:@"Example1", @"Example2", @"Example3", nil];
    
    for (i = 0; i < it; i++)
    {
        rect[i] = CGRectMake(pvWidthInitial,  (pvHeightInitial * i), pvWidth, pvHeight);
        pv[i]   = [[ProjectPreView alloc] initWithFrame:rect[i]];
        
        [pv[i] setProjectName:names[i] withParentView:self];
        
        [myProjectsView addSubview: pv[i]];
        
        pv[i].inEditingMode = false;
    }
    
    [self changeScrollHeight:(pvHeightInitial * it)];
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

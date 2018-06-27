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
    HomeView *hv;
    int hvHeightInitial, hvHeight;
    int hvWidthInitial, hvWidth;
    int viewWidth, viewHeight;
    
    UITextField *searchBar;
    CGRect searchFrame;
    int searchHeightInitial, searchHeight;
    
}

- (void) setup
{
    hvHeightInitial = 85;
    hvWidthInitial = 0;
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    
    hvWidth = viewWidth - (2 * hvWidthInitial);
    hvHeight = viewHeight - hvHeightInitial;
    
    searchHeightInitial = 30;
    searchHeight = hvHeightInitial - (searchHeightInitial + 20);
    
    searchFrame = CGRectMake(10, searchHeightInitial, (viewWidth - 20), searchHeight);
    
}

- (UITabBarItem *)tabBarItem
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Home" image:nil tag:0];
    return item;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    searchBar = [[UITextField alloc] initWithFrame:searchFrame];
    searchBar.borderStyle = UITextBorderStyleRoundedRect;
    searchBar.placeholder = @"Search...";
    searchBar.returnKeyType = UIReturnKeyGo;
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    
    hv = [[HomeView alloc] initWithFrame:CGRectMake(hvWidthInitial, hvHeightInitial, hvWidth, hvHeight)];
    [self.view addSubview:hv];
    
    self.view.backgroundColor = [UIColor blackColor];
    hv.backgroundColor = [UIColor whiteColor];
    
    [hv setNeedsDisplay];
    
    
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


@end

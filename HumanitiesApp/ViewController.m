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
    
    
    
}

- (void) setup
{
    hvHeightInitial = 85;
    hvWidthInitial = 0;
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    
    hvWidth = viewWidth - (2 * hvWidthInitial);
    hvHeight = viewHeight - hvHeightInitial;
    
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
    
    
    hv = [[HomeView alloc] initWithFrame:CGRectMake(hvWidthInitial, hvHeightInitial, hvWidth, hvHeight)];
    [self.view addSubview:hv];
    
    self.view.backgroundColor = [UIColor whiteColor];
    hv.backgroundColor = [UIColor blackColor];
    
    [hv setNeedsDisplay];
    
    
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

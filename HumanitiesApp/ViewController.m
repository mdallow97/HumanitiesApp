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
    ProjectView *pv;
    
}

- (UITabBarItem *)tabBarItem
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Home" image:nil tag:0];
    return item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    
    pv = [[ProjectView alloc] initWithFrame:CGRectMake(20, 25, (viewWidth - 40), 300)];
    [self.view addSubview:pv];
    
    self.view.backgroundColor = [UIColor whiteColor];
    pv.backgroundColor = [UIColor grayColor];
    
    [pv setNeedsDisplay];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ProjectView.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/26/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "ProjectView.h"

@interface ProjectView ()

@end

@implementation ProjectView
{
    UIButton *cancelButton;
    CGRect cancelFrame;
    int viewWidth, viewHeight;
}

- (void) setup
{
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    
    cancelFrame = CGRectMake(10, 25, 50, 25);
}

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.frame = cancelFrame;
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

-(void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

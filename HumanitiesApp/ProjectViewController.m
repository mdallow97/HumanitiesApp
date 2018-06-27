//
//  ProjectViewController.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/26/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "ProjectViewController.h"


@interface ProjectViewController ()

@end

@implementation ProjectViewController

- (void)viewWillAppear:(BOOL)animated
{
    ProjectView *view = [ProjectView new];
    view.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) other
{
    NSLog(@"Here\n");
    
    UIAlertController *options = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *share = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [options addAction:cancel];
    [options addAction:share];
    
    
    [self presentViewController:options animated:YES completion:NULL];
    
}

@end

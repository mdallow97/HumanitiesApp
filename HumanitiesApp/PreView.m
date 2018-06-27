//
//  PreView.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/26/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "PreView.h"

@interface PreView ()

@end

@implementation PreView
{
    UILabel *usernameLabel;
    UIButton *moreButton, *goToProjectButton;
    UIImage *preview;
    CGRect usernameFrame, moreFrame, goToProjectFrame, previewFrame;
    
    int viewHeight, viewWidth;
    
    // Label variables
    int defaultLabelHeight, defaultLabelWidth;
    
    // Button variables
    int defaultButtonHeight, defaultButtonWidth;
    
    // Preview variables
    int defaultPreviewHeight;
}

- (void) setup
{
    viewWidth = self.frame.size.width;
    viewHeight = self.frame.size.height;
    
    int x;
    
    // Prepare frame for displaying the username label
    defaultLabelWidth = (viewWidth / 3) * 2;
    defaultLabelHeight = 50;
    
    // Prepare frame for displaying more options button
    defaultButtonWidth = 50;
    defaultButtonHeight = 25;
    
    // Prepare frame for displaying preview image
    defaultPreviewHeight = viewHeight - defaultLabelHeight;
    preview = [UIImage imageNamed:@"preview.png"];
    
    
    x = 10;
    usernameFrame = CGRectMake(x, 0, defaultLabelWidth, defaultLabelHeight);
    
    
    x = viewWidth - (defaultButtonWidth + x);
    moreFrame = CGRectMake(x, 0, defaultButtonWidth, defaultButtonHeight);
    
    x = 0;
    previewFrame = CGRectMake(x, defaultLabelHeight, viewWidth, defaultPreviewHeight);
    
    goToProjectFrame = previewFrame;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setup];
    
    // Username Label Creation
    usernameLabel = [[UILabel alloc] initWithFrame:usernameFrame];
    usernameLabel.text = @"Username";
    [self addSubview:usernameLabel];
    
    // More Options Button Creation
    moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moreButton.frame = moreFrame;
    [moreButton setTitle:@"..." forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:35];
    [moreButton addTarget:self action:@selector(showOptions) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreButton];
    
    // Preview image setup
    UIImageView *previewView = [[UIImageView alloc] initWithFrame:previewFrame];
    [previewView setImage:preview];
    [previewView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:previewView];
    
    // Go To Project Button setup
    goToProjectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goToProjectButton.frame = goToProjectFrame;
    [goToProjectButton addTarget:self action:@selector(goToProject) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goToProjectButton];
    
    
    
    return self;
}

- (void) showOptions
{
    UIAlertController *options = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *share = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    // Below action should be dependent on permissions
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:nil];

    [options addAction:cancel];
    [options addAction:share];
    [options addAction:edit];

    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:options animated:YES completion:nil];
    
}

- (void) goToProject
{
    ProjectView *project = [[ProjectView alloc] init];
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:project animated:YES completion:nil];
}

- (UIViewController *) currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (topVC.presentedViewController)
        topVC = topVC.presentedViewController;
    
    return topVC;
}







@end

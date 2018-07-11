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
    UILabel *projectNameLabel;
    UIButton *moreButton, *goToProjectButton;
    UIImage *preview;
    CGRect projectNameFrame, moreFrame, goToProjectFrame, previewFrame;
    NSString *projectName;
    
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
    defaultButtonHeight = 35;
    
    // Prepare frame for displaying preview image
    defaultPreviewHeight = viewHeight - defaultLabelHeight;
    preview = [UIImage imageNamed:@"preview.png"];
    
    
    x = 10;
    projectNameFrame = CGRectMake(x, 5, defaultLabelWidth, defaultLabelHeight);
    
    
    x = viewWidth - (defaultButtonWidth + x);
    moreFrame = CGRectMake(x, 0, defaultButtonWidth, defaultButtonHeight);
    
    x = 0;
    previewFrame = CGRectMake(x, defaultLabelHeight, viewWidth, defaultPreviewHeight);
    
    goToProjectFrame = previewFrame;
}

- (void) setProjectName:(NSString *)name
{
    projectName = name;
    projectNameLabel.text = projectName;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setup];
    
    self.backgroundColor = [UIColor whiteColor];
    
    // Username Label Creation
    projectNameLabel = [[UILabel alloc] initWithFrame:projectNameFrame];
    projectNameLabel.font = [UIFont fontWithName:@"DamascusBold" size:16];
    
    
    // More Options Button Creation
    moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moreButton.frame = moreFrame;
    [moreButton setTitle:@"..." forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:35];
    [moreButton addTarget:self action:@selector(showOptions) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Preview image setup
    UIImageView *previewView = [[UIImageView alloc] initWithFrame:previewFrame];
    [previewView setImage:preview];
    [previewView setContentMode:UIViewContentModeScaleAspectFit];
    
    // Go To Project Button setup
    goToProjectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goToProjectButton.frame = goToProjectFrame;
    [goToProjectButton addTarget:self action:@selector(goToProject) forControlEvents:UIControlEventTouchUpInside];
    
    
    _inEditingMode = false;
    
    // Add Subviews
    [self addSubview:projectNameLabel];
    [self addSubview:moreButton];
    [self addSubview:previewView];
    [self addSubview:goToProjectButton];
    
    
    return self;
}

- (void) showOptions
{
    UIAlertController *options = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *share = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    // Below action should be dependent on permissions
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self goToProject:true];
        
    }];
    
    
    if (self->_inEditingMode) {
        [options addAction:edit];
    }
    
    
    [options addAction:cancel];
    [options addAction:share];
    

    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:options animated:YES completion:nil];
    
}

- (void) goToProject:(BOOL) canEdit
{
    ProjectView *project = [[ProjectView alloc] init];
    
    
    UserData *projects = [UserData sharedMyProjects];
    ProjectData *pd = [projects projectNamed:projectName];
    
    [project loadProjectWithData:pd];
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:project animated:YES completion:nil];
    
    
    if (canEdit) {
        [project enterEditingMode];
    }
}

- (void) goToProject
{
    
    if (self->_inEditingMode) [self goToProject:true];
    else [self goToProject:false];
}

- (UIViewController *) currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (topVC.presentedViewController)
        topVC = topVC.presentedViewController;
    
    return topVC;
}







@end

//
//  FilePreView.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/11/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "FilePreView.h"

@interface FilePreView ()

@end

@implementation FilePreView
{
    ProjectData *currentProject;
    
    UILabel *fileNameLabel;
    UIButton *moreButton, *goToFileButton;
    UIImage *preview;
    CGRect fileNameFrame, moreFrame, goToFileFrame, previewFrame;
    NSString *fileName;
    
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
    fileNameFrame = CGRectMake(x, 5, defaultLabelWidth, defaultLabelHeight);
    
    
    x = viewWidth - (defaultButtonWidth + x);
    moreFrame = CGRectMake(x, 0, defaultButtonWidth, defaultButtonHeight);
    
    x = 0;
    previewFrame = CGRectMake(x, defaultLabelHeight, viewWidth, defaultPreviewHeight);
    
    goToFileFrame = previewFrame;
}

- (void) setFileName:(NSString *)name inProject: (ProjectData *) project
{
    fileName = name;
    currentProject = project;
    fileNameLabel.text = fileName;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setup];
    
    self.backgroundColor = [UIColor whiteColor];
    
    // Username Label Creation
    fileNameLabel      = [[UILabel alloc] initWithFrame:fileNameFrame];
    fileNameLabel.font = [UIFont fontWithName:@"DamascusBold" size:16];
    
    
    // More Options Button Creation
    moreButton                 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moreButton.frame           = moreFrame;
    moreButton.titleLabel.font = [UIFont systemFontOfSize:35];
    [moreButton setTitle:@"..." forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(showOptions) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Preview image setup
    UIImageView *previewView = [[UIImageView alloc] initWithFrame:previewFrame];
    [previewView setImage:preview];
    [previewView setContentMode:UIViewContentModeScaleAspectFit];
    
    // Go To Project Button setup
    goToFileButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    goToFileButton.frame = goToFileFrame;
    [goToFileButton addTarget:self action:@selector(goToFile) forControlEvents:UIControlEventTouchUpInside];
    
    
    _inEditingMode = false;
    
    // Add Subviews
    [self addSubview:fileNameLabel];
    [self addSubview:moreButton];
    [self addSubview:previewView];
    [self addSubview:goToFileButton];
    
    
    return self;
}

- (void) showOptions
{
    UIAlertController *options = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *share = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    // Below action should be dependent on permissions
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self goToFile:true];
        
    }];
    
    
    if (self->_inEditingMode) {
        [options addAction:edit];
    }
    
    
    [options addAction:cancel];
    [options addAction:share];
    
    
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:options animated:YES completion:nil];
    
}

- (void) goToFile:(BOOL) canEdit
{
    FileView *fileView = [[FileView alloc] init];
    
    FileData *fileData = [currentProject fileNamed:fileName];
    
    [fileView loadFileWithData:fileData];
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:fileView animated:YES completion:nil];
    
    
    if (canEdit) {
        [fileView enterEditingMode];
    }
}

- (void) goToFile
{
    
    if (self->_inEditingMode) [self goToFile:true];
    else [self goToFile:false];
}

- (UIViewController *) currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (topVC.presentedViewController)
        topVC = topVC.presentedViewController;
    
    return topVC;
}




@end

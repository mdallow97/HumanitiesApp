//
//  PreView.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/26/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "ProjectPreView.h"

@interface ProjectPreView ()

@end

@implementation ProjectPreView
{
    PersonalPageViewController *parent_view;
    ProjectData *project;
    
    UILabel *project_name_LBL;
    UIButton *more_button, *go_to_project_button;
    UIImage *preview;
    NSString *project_name;
    NSString *project_ID;
    UIImageView *preview_view;
    
    int view_height, view_width;
}

- (void) setProjectName:(NSString *)name andID:(NSString *) Id withParentView:(PersonalPageViewController *) parentView
{
    
    project_name        = name;
    project_ID          = Id;
    self->parent_view   = parentView;
    
    UserData *projects  = [UserData sharedMyProjects];
    
    if (Id == nil)
        project         = [projects userProjectNamed:project_name];
    else
    {
        project         = [projects followerProjectWithId:Id];
    }
    if (project.previewImage) [preview_view setImage:project.previewImage];
    
    project_name_LBL.text = project_name;
    
    
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    view_width  = self.frame.size.width;
    view_height = self.frame.size.height;
    preview     = [UIImage imageNamed:@"preview.png"];
    
    self.backgroundColor = [UIColor whiteColor];
    
    // Username Label Creation
    project_name_LBL      = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, (view_width / 3) * 2, 50)];
    project_name_LBL.font = [UIFont fontWithName:@"DamascusBold" size:16];
    
    
    // More Options Button Creation
    more_button                 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    more_button.frame           = CGRectMake(view_width - 60, 0, 50, 35);
    more_button.titleLabel.font = [UIFont systemFontOfSize:35];
    [more_button setTitle:@"..." forState:UIControlStateNormal];
    [more_button addTarget:self action:@selector(showOptions) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Preview image setup
    preview_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, view_width, view_height - 50)];
    [preview_view setImage:preview];
    [preview_view setContentMode:UIViewContentModeScaleAspectFit];
    
    // Go To Project Button setup
    go_to_project_button       = [UIButton buttonWithType:UIButtonTypeCustom];
    go_to_project_button.frame = CGRectMake(0, 50, view_width, view_height - 50);
    [go_to_project_button addTarget:self action:@selector(goToProject) forControlEvents:UIControlEventTouchUpInside];
    
    
    _inEditingMode = false;
    
    // Add Subviews
    [self addSubview:project_name_LBL];
    [self addSubview:more_button];
    [self addSubview:preview_view];
    [self addSubview:go_to_project_button];
    
    
    return self;
}

- (void) showOptions
{
    UIAlertController *options = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *share = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    // Below action should be dependent on permissions
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self goToProject:true];}];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete Project" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {[self deleteProject];}];
    
    [options addAction:share];
    
    if (self->_inEditingMode) {
        [options addAction:edit];
        [options addAction:delete];
    }
    
    [options addAction:cancel];

    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:options animated:YES completion:nil];
    
}

- (void) deleteProject
{
    UserData *ud = [UserData sharedMyProjects];
    
    ProjectData *project_to_remove = [ud userProjectNamed:project_name];
    [ud.user_projects removeObject:project_to_remove];
    
    [self removeFromSuperview];
    
    [parent_view createPreviews];
}

- (void) goToProject:(BOOL) canEdit
{
    ProjectView *project    = [[ProjectView alloc] init];
    UserData *projects      = [UserData sharedMyProjects];
    ProjectData *pd;
    
    if (project_ID == nil)
    {
        pd = [projects userProjectNamed:project_name];
    }
    else
    {
        pd = [projects followerProjectWithId:project_ID];
    }
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

//
//  PreView.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/26/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef ProjectPreView_h
#define ProjectPreView_h

#import <UIKit/UIKit.h>
#import "ProjectView.h"
#import "PersonalPageViewController.h"
#import "UserData.h"


@interface ProjectPreView : UIView

- (id) initWithFrame:(CGRect)frame;
- (void) setup;
- (void) showOptions;
- (void) deleteProject;
- (UIViewController *) currentTopViewController;
- (void) goToProject;
- (void) goToProject:(BOOL) canEdit;
- (void) setProjectName:(NSString *)name andID:(NSString *) Id withParentView:(UIViewController *) parentView;

@property BOOL inEditingMode;
//@property NSString *name;




@end


#endif /* ProjectPreView_h */

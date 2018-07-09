//
//  ProjectView.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/26/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef ProjectView_h
#define ProjectView_h


#import <UIKit/UIKit.h>
#import "ProjectData.h"
#import "UserData.h"

@interface ProjectView : UIViewController <UITextFieldDelegate>

- (void) viewDidLoad;
- (void) frameSetup;
- (void) done;
- (void) showEditingOptions;
- (void) enterNewProjectMode;
- (void) createProject;
- (void) enterEditingMode;

- (void) loadProjectWithData:(ProjectData *) project;

- (UIViewController *) currentTopViewController;

@property NSString *currentProjectName;



@end

#endif /* ProjectView_h */

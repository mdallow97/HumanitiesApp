//
//  PersonalPageViewController.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/28/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef PersonalPageViewController_h
#define PersonalPageViewController_h

#import <UIKit/UIKit.h>
#import "PreView.h"
#import "UserData.h"
#import "ProjectData.h"
#import "ProjectView.h"

@interface PersonalPageViewController : UIViewController

- (void) viewDidLoad;
- (void) createPreviews;
- (void) createNewProject;
- (void) changeScrollHeight: (int) height;
- (UIViewController *) currentTopViewController;
- (void) frameSetup;
- (UITabBarItem *)tabBarItem;

@end

#endif /* PersonalPageViewController_h */

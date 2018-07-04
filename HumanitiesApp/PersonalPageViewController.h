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
#import "ProjectView.h"

@interface PersonalPageViewController : UIViewController

- (void) viewDidLoad;
- (void) createPreView:(int) it;
- (void) createNewProject;
- (UIViewController *) currentTopViewController;

@end

#endif /* PersonalPageViewController_h */

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


@interface ProjectView : UIViewController <UITextFieldDelegate>

- (void) viewDidLoad;
- (void) setup;
- (void) cancel;
- (void) addFile;
- (void) enterNewProjectMode;
- (void) createProject;
- (void) enterEditingMode;



@end

#endif /* ProjectView_h */

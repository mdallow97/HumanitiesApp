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
#import "HomeView.h"
#import "ViewController.h"


@interface ProjectView : UIView

- (id) initWithFrame:(CGRect)frame;
- (void) setup;
- (void) showOptions;
- (UIViewController *) currentTopViewController;




@end


#endif /* ProjectView_h */

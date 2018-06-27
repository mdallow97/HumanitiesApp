//
//  PreView.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/26/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef PreView_h
#define PreView_h

#import <UIKit/UIKit.h>
#import "ProjectView.h"


@interface PreView : UIView

- (id) initWithFrame:(CGRect)frame;
- (void) setup;
- (void) showOptions;
- (UIViewController *) currentTopViewController;
- (void) goToProject;




@end


#endif /* PreView_h */

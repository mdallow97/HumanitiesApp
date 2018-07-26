//
//  FilePreView.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/11/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef FilePreView_h
#define FilePreView_h

#import <UIKit/UIKit.h>
#import "FileView.h"
#import "ProjectView.h"

@interface FilePreView : UIView

- (id) initWithFrame:(CGRect)frame;
- (void) setup;
- (void) showOptions;
- (UIViewController *) currentTopViewController;
- (void) goToFile;
- (void) goToFile:(BOOL) canEdit;
- (void) setFileName:(NSString *)name inProject: (ProjectData *) project withParentView:(UIViewController *) parentView;
- (void) deleteFile;
- (void) enterEditingMode;

@property BOOL inEditingMode;

@end

#endif /* FilePreView_h */

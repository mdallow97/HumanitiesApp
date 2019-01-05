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
#import "FileView.h"
#import "FilePreView.h"

@interface ProjectView : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// General Functions
- (void) viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (NSString *) interactWithDatabase: (NSString *) username with: (NSString *) password at: (NSString *)path;
-(NSMutableArray *) toArray:(NSString *)data;
- (void) done;
- (void) createPreviews;
- (void) changeScrollHeight:(int)height;
- (UIViewController *) currentTopViewController;

// Project Functions
- (void) enterNewProjectMode;
- (void) createProject;
- (void) deleteProject;
- (void) changePreviewImage;
- (void) openCamera;
- (void) openPhotos;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker;
- (void) cancel;
- (void) presentEditingOptions;
- (void) enterEditingMode;
- (void) loadProjectWithData:(ProjectData *) project;

@property NSString *current_project_name;
@property NSString *current_project_ID;
@property BOOL in_editing_mode;


- (void) createFileOfType:(int) type;

- (BOOL) textFieldShouldReturn:(UITextField *)textField;


@end

#endif /* ProjectView_h */

//
//  FileView.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/9/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef FileView_h
#define FileView_h

#import <UIKit/UIKit.h>
#import "UserData.h"
#import "ProjectData.h"
#import "FileData.h"
//#import "QuartzCore/QuartzCore.h"


@interface FileView : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// General Functions
- (void) viewDidLoad;
- (void) hideAll;
- (void) inProject:(ProjectData *) project;
- (void) loadFileWithData:(FileData *) file inProject:(ProjectData *) project;

@property ProjectData *current_project;
@property FileData *current_file;
@property NSString *current_file_name;
@property BOOL in_editing_mode;
@property(readonly, copy) NSDictionary *user_info;

// Functions only available in editing mode
- (void) enterEditingMode;

- (void) createFileOfType:(int) type;
- (BOOL) isFileNameEmptyOrTaken;
- (void) saveFileName:(NSString *) name;
- (void) changeFileDescription;
- (void) postComment;
- (NSString *) interactWithDatabase: (NSString *) fileName with: (int) fileType and: (NSString *) desc and: (NSString *) projId at:(NSString *)path;
- (void) createDocument;
- (void) createPresentation;

- (void) createImage;
- (void) openCamera;
- (void) openPhotos;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker;

- (void) createAudio;
- (void) createVideo;
- (void) createAR;


// Functions only available in viewing mode
- (void) enterViewingMode;




@property enum {
DOCUMENT,
PRESENTATION,
IMAGE,
AUDIO,
VIDEO,
AUGMENTED_REALITY
};

- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (void) textViewDidBeginEditing:(UITextView *)textView;
- (void) keyboardWillShow:(NSNotification *)notification;


- (UIViewController *) currentTopViewController;

@end

#endif /* FileView_h */

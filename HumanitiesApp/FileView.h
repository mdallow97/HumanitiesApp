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
#import "ProjectData.h"
#import "FileData.h"

@interface FileView : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// General Functions
- (void) viewDidLoad;
- (void) frameSetup;
- (void) hideAll;
- (void) inProject:(ProjectData *) project;
- (void) loadFileWithData:(FileData *) file inProject:(ProjectData *) project;

@property NSString *currentFileName;

// Functions only available in editing mode
- (void) enterEditingMode;

- (void) createFileOfType:(int) type;
- (BOOL) isFileNameEmptyOrTaken;
- (void) saveFileName:(NSString *) name;


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
- (UIViewController *) currentTopViewController;

@end

#endif /* FileView_h */

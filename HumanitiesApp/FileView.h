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

@property NSString *currentFileName;

// File Functions
- (void) createFileOfType:(int) type;

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

- (void) enterEditingMode;

- (BOOL) isFileNameEmptyOrTaken;
- (void) saveFileWithName:(NSString *) name;
- (void) loadFileWithData: (FileData *) file;


@property enum {
DOCUMENT,
PRESENTATION,
IMAGE,
AUDIO,
VIDEO,
AUGMENTED_REALITY
};


@end

#endif /* FileView_h */

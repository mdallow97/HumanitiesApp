//
//  FileView.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/9/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "FileView.h"

@interface FileView ()
@end

@implementation FileView
{
    // General Variable Declaration
    int viewWidth, viewHeight;
    int buttonWidth, buttonHeight;
    
    BOOL shouldAddFile;
    
    ProjectData *projectData;
    FileData *fileData;
    
    // Cancel Button Variable Declarations
    UIButton *cancelButton;
    int cancelX, cancelY;
    CGRect cancelFrame;
    
    // Project Name Label Variable Declaration
    UILabel *projectNameLabel;
    int projectNameWidth, projectNameHeight;
    CGRect projectNameFrame;
    
    // EDITING MODE Variables:
    
    // Next Button
    UIButton *nextButton;
    CGRect nextFrame;
    
    // Save Button Variable Declarations
    UIButton *saveButton;
    CGRect saveFrame;
    
    
    // NEW PROJECT MODE Variable Declarations:
    
    // New Project Name Text Field
    int textFieldWidth, textFieldHeight;
    UITextField *nameTextField;
    
    // New Project Name Empty Label
    UILabel *errorFieldLabel;
    int errorFieldWidth, errorFieldHeight;
    CGRect errorFieldFrame;
}


// General Function Definitions

- (void) frameSetup
{
    // General Variable Initialization
    viewWidth           = self.view.frame.size.width;
    viewHeight          = self.view.frame.size.height;
    
    shouldAddFile       = false;
    
    buttonWidth         = 50;
    buttonHeight        = 50;
    
    // Cancel Button Variable Initialization
    cancelFrame         = CGRectMake(10, 30, buttonWidth, buttonHeight);
    
    // Add File Button Variable Initialization
    cancelX             = viewWidth - (buttonWidth + 5);
    cancelY             = 30;
    
    saveFrame           = CGRectMake(cancelX, cancelY, buttonWidth, buttonHeight);
    
    // Next Button Variable Initialization
    nextFrame           = saveFrame;
    
    // General Text Field Variable Initialization
    textFieldWidth      = 250;
    textFieldHeight     = 50;
    
    // Empty Name Label Variable Initialization
    errorFieldWidth     = 250;
    errorFieldHeight    = 50;
    errorFieldFrame     = CGRectMake((viewWidth / 2) - (errorFieldWidth / 2), (viewHeight / 2), errorFieldWidth, errorFieldHeight);
    
    // Project Name Label Variable Initialization
    projectNameWidth    = 200;
    projectNameHeight   = 50;
    projectNameFrame    = CGRectMake((viewWidth / 2) - (projectNameWidth / 2), 30, projectNameWidth, projectNameHeight);
}

- (void) inProject:(ProjectData *) project
{
    projectData = project;
}

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self frameSetup];
    
    
    // Data will be nil if file does not exist
    fileData = [projectData fileNamed:self->_currentFileName];
    
    saveButton          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.hidden   = YES;
    saveButton.frame    = saveFrame;
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton        = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame  = cancelFrame;
    cancelButton.hidden = YES;
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    nextButton          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextButton.frame    = nextFrame;
    nextButton.hidden   = YES;
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    // nextButton target is dependent on file type
    
    
    nameTextField                   = [[UITextField alloc] initWithFrame:CGRectMake((viewWidth / 2) - (textFieldWidth / 2), (viewHeight / 3), textFieldWidth, textFieldHeight)];
    self->nameTextField.placeholder = @"New File Name";
    nameTextField.hidden            = YES;
    nameTextField.borderStyle       = UITextBorderStyleRoundedRect;
    nameTextField.tintColor         = [UIColor blueColor];
    nameTextField.backgroundColor   = [UIColor lightGrayColor];
    nameTextField.returnKeyType     = UIReturnKeyDone;
    nameTextField.textAlignment     = NSTextAlignmentCenter;
    nameTextField.delegate          = self;
    
    
    // Empty Project Name Label Setup
    errorFieldLabel                 = [[UILabel alloc] initWithFrame:errorFieldFrame];
    errorFieldLabel.textAlignment   = NSTextAlignmentCenter;
    errorFieldLabel.hidden          = YES;
    errorFieldLabel.textColor       = [UIColor redColor];
    
    [self hideAll];
    
    // Adding Subviews
    [self.view addSubview:saveButton];
    [self.view addSubview:cancelButton];
    [self.view addSubview:nextButton];
    [self.view addSubview:nameTextField];
    [self.view addSubview:errorFieldLabel];
}

- (void) loadFileWithData:(FileData *) file inProject:(ProjectData *) project
{
    _currentFileName = file.fileName;
    projectData = project;
}

- (void) save
{
    if (shouldAddFile) {
        [projectData.files addObject:fileData];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) hideAll
{
    saveButton.hidden       = YES;
    cancelButton.hidden     = YES;
    nextButton.hidden       = YES;
    nameTextField.hidden    = YES;
    errorFieldLabel.hidden  = YES;
}

- (void) enterEditingMode
{
    cancelButton.hidden = NO;
    
    // Edit file of a certain type
    if (fileData.fileType == DOCUMENT) {
        
    } else if (fileData.fileType == PRESENTATION) {
        
    } else if (fileData.fileType == IMAGE) {
        // Add change button in upper right corner
    } else if (fileData.fileType == AUDIO) {
        
    } else if (fileData.fileType == VIDEO) {
        
    } else if (fileData.fileType == AUGMENTED_REALITY) {
        
    }
    
    [self enterViewingMode];
}

- (void) enterViewingMode
{
    CGRect fileViewFrame = CGRectMake(0, 85, viewWidth, ((viewHeight - 85) / 2));
    
    
    // Open file of a certain type
    if (fileData.fileType == DOCUMENT) {
        
    } else if (fileData.fileType == PRESENTATION) {
        
    } else if (fileData.fileType == IMAGE) {
        
        UIImageView *fileView = [[UIImageView alloc] initWithFrame:fileViewFrame];
        [fileView setImage:fileData.image];
        [fileView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self.view addSubview:fileView];
        
    } else if (fileData.fileType == AUDIO) {
        
    } else if (fileData.fileType == VIDEO) {
        
    } else if (fileData.fileType == AUGMENTED_REALITY) {
        
    }
    
    
}


- (void) createFileOfType:(int) type
{
    [self hideAll];
    cancelButton.hidden         = NO;
    nextButton.hidden           = NO;
    nameTextField.hidden        = NO;
    
    // create file with type
    fileData            = [[FileData alloc] init];
    nameTextField.text  = @"";
    fileData.fileType   = type;
    
    [nameTextField becomeFirstResponder];
    
    // start creation of file, dependent on type of file
    if (type == DOCUMENT) {
        [nextButton addTarget:self action:@selector(createDocument) forControlEvents:(UIControlEventTouchUpInside)];
        [nameTextField addTarget:self action:@selector(createDocument) forControlEvents:(UIControlEventEditingDidEnd)];
    } else if (type == PRESENTATION) {
        [nextButton addTarget:self action:@selector(createPresentation) forControlEvents:(UIControlEventTouchUpInside)];
        [nameTextField addTarget:self action:@selector(createPresentation) forControlEvents:(UIControlEventEditingDidEnd)];
    } else if (type == IMAGE) {
        [nextButton addTarget:self action:@selector(createImage) forControlEvents:(UIControlEventTouchUpInside)];
        [nameTextField addTarget:self action:@selector(createImage) forControlEvents:(UIControlEventEditingDidEnd)];
    } else if (type == AUDIO) {
        [nextButton addTarget:self action:@selector(createAudio) forControlEvents:(UIControlEventTouchUpInside)];
        [nameTextField addTarget:self action:@selector(createAudio) forControlEvents:(UIControlEventEditingDidEnd)];
    } else if (type == VIDEO) {
        [nextButton addTarget:self action:@selector(createVideo) forControlEvents:(UIControlEventTouchUpInside)];
        [nameTextField addTarget:self action:@selector(createVideo) forControlEvents:(UIControlEventEditingDidEnd)];
    } else if (type == AUGMENTED_REALITY) {
        [nextButton addTarget:self action:@selector(createAR) forControlEvents:(UIControlEventTouchUpInside)];
        [nameTextField addTarget:self action:@selector(createAR) forControlEvents:(UIControlEventEditingDidEnd)];
    }
}


- (BOOL) isFileNameEmptyOrTaken
{
    [nameTextField resignFirstResponder];
    // Check to make sure text field is not empty
    if ([nameTextField.text isEqual:@""])
    {
        errorFieldLabel.text    = @"File name cannot be blank";
        errorFieldLabel.hidden  = NO;
        
        return true;
    }
    
    errorFieldLabel.hidden = YES;
    
    // Check to make sure file name doesnt conflict with another file name within same project
    
    FileData *test = [projectData fileNamed:nameTextField.text];
    
    if ([test.fileName isEqualToString:nameTextField.text]) {
        errorFieldLabel.text    = @"File name taken";
        errorFieldLabel.hidden  = NO;
        return true;
    }
    
    
    
    NSString *name = nameTextField.text;
    [self hideAll];
    [self saveFileName:name];
    
    
    return false;
}

- (void) saveFileName:(NSString *)name
{
    shouldAddFile       = true;
    cancelButton.hidden = NO;
    
    // Store File Name
    fileData.fileName   = name;
    
}

/*
 Functions below will store the data pertaining to the kind of file

 Data will be stored in FileData. Need to have different objects in FileData,
 for different kinds of files.
*/
 
- (void) createDocument
{
    
    if ([self isFileNameEmptyOrTaken]) return;
    
}

- (void) createPresentation
{
    
    if ([self isFileNameEmptyOrTaken]) return;
    
}

- (void) createImage
{
    if ([self isFileNameEmptyOrTaken]) return;
    
    
    UIButton *takePhotoButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takePhotoButton.frame           = CGRectMake((viewWidth / 2) - (textFieldWidth / 2), (viewHeight / 3), textFieldWidth, textFieldHeight);
    takePhotoButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [takePhotoButton setTitle:@"Take a Photo" forState:UIControlStateNormal];
    [takePhotoButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *openPhotosButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openPhotosButton.frame           = CGRectMake((viewWidth / 2) - (textFieldWidth / 2), 2 * (viewHeight / 3), textFieldWidth, textFieldHeight);
    openPhotosButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [openPhotosButton setTitle:@"Open Photo Roll" forState:UIControlStateNormal];
    [openPhotosButton addTarget:self action:@selector(openPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:takePhotoButton];
    [self.view addSubview:openPhotosButton];
    
}

- (void) openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Device does not have camera" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
        
        [alertController addAction:alert];
        
        UIViewController *currentTopVC = [self currentTopViewController];
        [currentTopVC presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.allowsEditing            = YES;
    camera.sourceType               = UIImagePickerControllerSourceTypeCamera;
    camera.delegate                 = self;
    
    [self presentViewController:camera animated:YES completion:nil];
}

- (void) openPhotos
{
    UIImagePickerController *photoRoll  = [[UIImagePickerController alloc] init];
    photoRoll.allowsEditing             = YES;
    photoRoll.sourceType                = UIImagePickerControllerSourceTypePhotoLibrary;
    photoRoll.delegate                  = self;
    
    [self presentViewController:photoRoll animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    if (editedImage)    [fileData storeImage:editedImage];
    else                [fileData storeImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self save];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) createAudio
{
    if ([self isFileNameEmptyOrTaken]) return;
    
}

- (void) createVideo
{
    
    if ([self isFileNameEmptyOrTaken]) return;
    
}

- (void) createAR
{
    
    if ([self isFileNameEmptyOrTaken]) return;
    
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == nameTextField) {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}






- (UIViewController *) currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (topVC.presentedViewController)
        topVC = topVC.presentedViewController;
    
    return topVC;
}


@end

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
    
    // File Name Label Variable Declaration
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
    
    // Viewing Mode
    
    UIButton *postCommentButton;
    CGRect postFrame;
    int keyboardHeight;
    
    
    // NEW PROJECT MODE Variable Declarations:
    
    // New File Name Text Field
    int textFieldWidth, textFieldHeight;
    UITextField *nameTextField;
    
    // New File Name Empty Label
    UILabel *errorFieldLabel;
    int errorFieldWidth, errorFieldHeight;
    CGRect errorFieldFrame;
    
    // File Type: Image
    UIButton *takePhotoButton;
    UIButton *openPhotosButton;
    
    // Description Text View Input
    UITextView *descriptionTV;
    UITextView *fileDescription;
    UITextField *commentTF;
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
    
    keyboardHeight = 335;
}

- (void) inProject:(ProjectData *) project
{
    projectData = project;
}

- (void) keyboardWillShow:(NSNotification *)notification {
    keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self frameSetup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _inEditingMode = false;
    
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

- (NSString *) interactWithDatabase: (NSString *) fileName with: (int) fileType and: (NSString *) desc and: (NSString *) projId at:(NSString *)path
{
    NSString *response;
    NSString *myRequestString;
    
    // Create your request string with parameter name as defined in PHP file
    myRequestString                 = [NSString stringWithFormat:@"fileName=%@&fileType=%d&desc=%@&projId=%@",fileName,fileType,desc,projId];
    
    // Create Data from request
    NSData *myRequestData           = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSString *url                   = [NSString stringWithFormat:@"http://humanitiesapp.atwebpages.com/%@", path];
    NSMutableURLRequest *request    = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    // Now send a request and get Response
    NSData *returnData  = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    
    // Log Response
    response            = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    
    return response;
}

- (void) save
{
    if (shouldAddFile)
    {
        NSLog(@"adds file");
        [projectData.files addObject:fileData];
        
        //NSData *imageData = UIImagePNGRepresentation(projectData.previewImage);
        //NSString *imageBin = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLneLength];
        // NSLog(@"binary: %@", imageBin);
        NSString *reply = [self interactWithDatabase: fileData.fileName with: fileData.fileType and: descriptionTV.text and: projectData.projectId at:@"uploadFile.php"];
        NSLog(@"%@", reply);
    }
    if (descriptionTV.text) [fileData storeDescription:descriptionTV.text];
    if ([descriptionTV isFirstResponder]) [descriptionTV resignFirstResponder];
    
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
    openPhotosButton.hidden = YES;
    takePhotoButton.hidden  = YES;
}

- (void) enterEditingMode
{
    _inEditingMode      = true;
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
    UserData *currentUser                   = [UserData sharedMyProjects];
    
    CGRect scrollFrame                      = CGRectMake(0, 85, viewWidth, (viewHeight - 85));
    UIScrollView *mainScrollView            = [[UIScrollView alloc] initWithFrame:scrollFrame];
    mainScrollView.contentSize              = CGSizeMake(viewWidth, 4000);
    
    CGRect fileViewFrame                    = CGRectMake(0, 0, viewWidth, (viewHeight / 3));
    
    CGRect usernameFrame                    = CGRectMake(10, ((viewHeight / 3) + 20), 50, 30);
    UILabel *usernameLabel                  = [[UILabel alloc] initWithFrame:usernameFrame];
    usernameLabel.text                      = currentUser.username;
    usernameLabel.font                      = [UIFont fontWithName:@"DamascusBold" size:16];
    
    CGRect descriptionFrame                 = CGRectMake(10, ((viewHeight / 3) + 40), (viewWidth - 20), 125);
    fileDescription                         = [[UITextView alloc] initWithFrame:descriptionFrame];
    fileDescription.font                    = [UIFont systemFontOfSize:16];
    fileDescription.text                    = fileData.fileDescription;
    fileDescription.delegate                = self;
    fileDescription.scrollEnabled           = NO;
    
    CGRect commentFrame                     = CGRectMake(10, (viewHeight - 60), (viewWidth - 20), 35);
    commentTF                               = [[UITextField alloc] initWithFrame:commentFrame];
    commentTF.placeholder                   = @"Add comment here...";
    commentTF.borderStyle                   = UITextBorderStyleRoundedRect;
    commentTF.delegate                      = self;
    commentTF.returnKeyType                 = UIReturnKeyDone;
    
    
    if (_inEditingMode) fileDescription.editable    = true;
    else fileDescription.editable                   = false;
    
    
    
    [self.view addSubview:mainScrollView];
    [self.view addSubview:commentTF];
    
    // Open file of a certain type
    if (fileData.fileType == DOCUMENT) {
        
    } else if (fileData.fileType == PRESENTATION) {
        
    } else if (fileData.fileType == IMAGE) {
        
        UIImageView *fileView = [[UIImageView alloc] initWithFrame:fileViewFrame];
        [fileView setImage:fileData.image];
        [fileView setContentMode:UIViewContentModeScaleAspectFit];
        
        [mainScrollView addSubview:fileView];
        
    } else if (fileData.fileType == AUDIO) {
        
    } else if (fileData.fileType == VIDEO) {
        
    } else if (fileData.fileType == AUGMENTED_REALITY) {
        
    }
    
    
    
    
    [mainScrollView addSubview:fileDescription];
    [mainScrollView addSubview:usernameLabel];
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

// File description not necessary (user can skip adding a description)
- (void) changeFileDescription
{
    [self hideAll];
    
    // Unhide necessary objects
    saveButton.hidden = NO;
    
    // Create Description Text Field
    CGRect descriptionFrame         = CGRectMake(30, (viewHeight / 3), (viewWidth - 60), 200);
    
    descriptionTV                   = [[UITextView alloc] initWithFrame:descriptionFrame];
    descriptionTV.editable          = YES;
    descriptionTV.font              = [UIFont systemFontOfSize:16];
    descriptionTV.backgroundColor   = [UIColor whiteColor];
    
    // Create rectangle around frame of description
    UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(28, (viewHeight / 3) - 2, (viewWidth - 56), 204)];
    rectView.backgroundColor = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    
    UILabel *descriptionHere = [[UILabel alloc] initWithFrame:CGRectMake(30, (viewHeight / 3) - 30, 200, 30)];
    descriptionHere.text = @"Add a description below";
    
    [self.view addSubview:rectView];
    [self.view addSubview:descriptionHere];
    [self.view addSubview:descriptionTV];
    
}

- (void) postComment
{
    postCommentButton.hidden = YES;
    
    if ([fileDescription isFirstResponder]) [fileDescription resignFirstResponder];
    [fileData storeDescription:fileDescription.text];
    
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
    
    
    takePhotoButton                 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takePhotoButton.frame           = CGRectMake((viewWidth / 2) - (textFieldWidth / 2), (viewHeight / 3), textFieldWidth, textFieldHeight);
    takePhotoButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [takePhotoButton setTitle:@"Take a Photo" forState:UIControlStateNormal];
    [takePhotoButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    
    openPhotosButton                 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
//    [self save];
    
    [self changeFileDescription];
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
    } else if (textField == commentTF) {
        commentTF.frame = CGRectMake(10, (viewHeight - 60), (viewWidth - 20), 35);
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == commentTF) {
        
        commentTF.frame = CGRectMake(10, (keyboardHeight + 100), (viewWidth - 20), 35);
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    postFrame                               = CGRectMake((viewWidth / 2) - 25, (keyboardHeight + 100), 50, 50);
    postCommentButton                       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postCommentButton.frame                 = postFrame;
    postCommentButton.titleLabel.textColor  = [UIColor blueColor];
    postCommentButton.titleLabel.font       = [UIFont fontWithName:@"Arial-BoldMT" size:16];
//    postCommentButton.hidden                = YES;
    [postCommentButton setTitle:@"Post" forState:UIControlStateNormal];
    [postCommentButton addTarget:self action:@selector(postComment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:postCommentButton];
    
    if (textView == fileDescription) {
        postCommentButton.hidden = NO;
    }
}

- (UIViewController *) currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (topVC.presentedViewController)
        topVC = topVC.presentedViewController;
    
    return topVC;
}


@end

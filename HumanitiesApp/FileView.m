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
    int view_width, view_height;
    int button_width, button_height;
    
    BOOL should_add_file;
    
    // Cancel Button Variable Declarations
    UIButton *cancel_button;
    
    // EDITING MODE Variables:
    UIButton *next_button;
    UIButton *save_button;
    
    // Viewing Mode
    UIButton *post_comment_button;
    int keyboard_height;
    
    
    // NEW PROJECT MODE Variable Declarations:
    UITextField *file_name_TF;
    UILabel *error_LBL;
    
    // File Type: Image
    UIButton *take_photo_button;
    UIButton *open_camera_roll_button;
    
    // Description Text View Input
    UITextView *create_description_TV;
    UITextView *edit_description_TV;
    UITextField *comment_TF;
}

- (void) inProject:(ProjectData *) project
{
    _current_project = project;
}

- (void) keyboardWillShow:(NSNotification *)notification {
    keyboard_height = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    view_width      = self.view.frame.size.width;
    view_height     = self.view.frame.size.height;
    
    should_add_file = false;
    keyboard_height  = 335; // Typical keyboard height, cannot be zero when initialized or it will cause a bug
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _in_editing_mode = false;
    
    // Data will be nil if file does not exist
    _current_file = [_current_project fileNamed:self->_current_file_name];
    
    save_button          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    save_button.hidden   = YES;
    save_button.frame    = CGRectMake(view_width - 55, 30, 50, 50);
    [save_button setTitle:@"Save" forState:UIControlStateNormal];
    [save_button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    cancel_button        = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancel_button.frame  = CGRectMake(10, 30, 50, 50);
    cancel_button.hidden = YES;
    [cancel_button setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel_button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    next_button          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next_button.frame    = CGRectMake(view_width - 55, 30, 50, 50);
    next_button.hidden   = YES;
    [next_button setTitle:@"Next" forState:UIControlStateNormal];
    // nextButton target is dependent on file type
    
    
    file_name_TF                   = [[UITextField alloc] initWithFrame:CGRectMake((view_width / 2) - 125, (view_height / 3), 250, 50)];
    self->file_name_TF.placeholder = @"New File Name";
    file_name_TF.hidden            = YES;
    file_name_TF.borderStyle       = UITextBorderStyleRoundedRect;
    file_name_TF.tintColor         = [UIColor blueColor];
    file_name_TF.backgroundColor   = [UIColor lightGrayColor];
    file_name_TF.returnKeyType     = UIReturnKeyDone;
    file_name_TF.textAlignment     = NSTextAlignmentCenter;
    file_name_TF.delegate          = self;
    
    
    // Empty Project Name Label Setup
    error_LBL                 = [[UILabel alloc] initWithFrame:CGRectMake((view_width / 2) - 125, (view_height / 2), 250, 50)];
    error_LBL.textAlignment   = NSTextAlignmentCenter;
    error_LBL.hidden          = YES;
    error_LBL.textColor       = [UIColor redColor];
    
    [self hideAll];
    
    // Adding Subviews
    [self.view addSubview:save_button];
    [self.view addSubview:cancel_button];
    [self.view addSubview:next_button];
    [self.view addSubview:file_name_TF];
    [self.view addSubview:error_LBL];
}

- (void) loadFileWithData:(FileData *) file inProject:(ProjectData *) project
{
    _current_file_name  = file.fileName;
    _current_project    = project;
}

- (NSString *) interactWithDatabase: (NSString *) fileName with: (int) fileType and: (NSString *) desc and: (NSString *) projId at:(NSString *)path
{
    NSString *response;
    NSString *request_string;
    
    // Create your request string with parameter name as defined in PHP file
    request_string                  = [NSString stringWithFormat:@"fileName=%@&fileType=%d&desc=%@&projId=%@",fileName,fileType,desc,projId];
    
    // Create Data from request
    NSData *request_data            = [NSData dataWithBytes: [request_string UTF8String] length: [request_string length]];
    NSString *url                   = [NSString stringWithFormat:@"http://humanitiesapp.atwebpages.com/%@", path];
    NSMutableURLRequest *request    = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // Set Request Body
    [request setHTTPBody: request_data];
    
    // Now send a request and get Response
    NSData *return_data  = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    
    // Log Response
    response            = [[NSString alloc] initWithBytes:[return_data bytes] length:[return_data length] encoding:NSUTF8StringEncoding];
    
    return response;
}

- (void) save
{
    if (should_add_file)
    {
        [_current_project.files addObject:_current_file];
        
        NSString *reply = [self interactWithDatabase: _current_file.fileName with: _current_file.fileType and: create_description_TV.text and: _current_project.projectId at:@"uploadFile.php"];
        NSLog(@"%@", reply);
    }
    if (create_description_TV.text) [_current_file storeDescription:create_description_TV.text];
    if ([create_description_TV isFirstResponder]) [create_description_TV resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) hideAll
{
    save_button.hidden              = YES;
    cancel_button.hidden            = YES;
    next_button.hidden              = YES;
    file_name_TF.hidden             = YES;
    error_LBL.hidden                = YES;
    open_camera_roll_button.hidden  = YES;
    take_photo_button.hidden        = YES;
}

- (void) enterEditingMode
{
    _in_editing_mode = true;
    
    // Edit file of a certain type
    if (_current_file.fileType == DOCUMENT) {
        
    } else if (_current_file.fileType == PRESENTATION) {
        
    } else if (_current_file.fileType == IMAGE) {
        // Add change button in upper right corner
    } else if (_current_file.fileType == AUDIO) {
        
    } else if (_current_file.fileType == VIDEO) {
        
    } else if (_current_file.fileType == AUGMENTED_REALITY) {
        
    }
    
    [self enterViewingMode];
}

- (void) enterViewingMode
{
    cancel_button.hidden  = NO;
    
    UIScrollView *file_SV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 85, view_width, (view_height - 85))];
    file_SV.contentSize   = CGSizeMake(view_width, 4000);
    
    UILabel *username_LBL = [[UILabel alloc] initWithFrame:CGRectMake(10, ((view_height / 3) + 20), 50, 30)];
    UserData *local_user  = [UserData sharedMyProjects];
    
    if (_in_editing_mode) username_LBL.text = local_user.username;
    else username_LBL.text                  = [self interactWithDatabase: _current_file.fileId with: nil and: nil and: nil at:@"whoOwns.php"];
    username_LBL.font                       = [UIFont fontWithName:@"DamascusBold" size:16];

    edit_description_TV         = [[UITextView alloc] initWithFrame:CGRectMake(10, ((view_height / 3) + 40), (view_width - 20), 125)];
    edit_description_TV.font    = [UIFont systemFontOfSize:16];
    
    if (_current_file.fileDescription == nil)
        _current_file.fileDescription            = [self interactWithDatabase: _current_file.fileId with: nil and: nil and: nil at:@"fileDesc.php"];
    
    
    edit_description_TV.text                 = _current_file.fileDescription;
    edit_description_TV.delegate             = self;
    edit_description_TV.scrollEnabled        = NO;
    
    comment_TF                               = [[UITextField alloc] initWithFrame:CGRectMake(10, (view_height - 60), (view_width - 20), 35)];
    comment_TF.placeholder                   = @"Add comment here...";
    comment_TF.borderStyle                   = UITextBorderStyleRoundedRect;
    comment_TF.delegate                      = self;
    comment_TF.returnKeyType                 = UIReturnKeyDone;
    
    
    if (_in_editing_mode) edit_description_TV.editable    = true;
    else edit_description_TV.editable                   = false;
    
    
    
    [self.view addSubview:file_SV];
    [self.view addSubview:comment_TF];
    
    // Open file of a certain type
    if (_current_file.fileType == DOCUMENT) {
        
    } else if (_current_file.fileType == PRESENTATION) {
        
    } else if (_current_file.fileType == IMAGE) {
        
        UIImageView *file_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view_width, (view_height / 3))];
        [file_view setImage:_current_file.image];
        [file_view setContentMode:UIViewContentModeScaleAspectFit];
        
        [file_SV addSubview:file_view];
        
    } else if (_current_file.fileType == AUDIO) {
        
    } else if (_current_file.fileType == VIDEO) {
        
    } else if (_current_file.fileType == AUGMENTED_REALITY) {
        
    }
    
    
    
    
    [file_SV addSubview:edit_description_TV];
    [file_SV addSubview:username_LBL];
}


- (void) createFileOfType:(int) type
{
    [self hideAll];
    cancel_button.hidden    = NO;
    next_button.hidden      = NO;
    file_name_TF.hidden     = NO;
    
    // create file with type
    _current_file           = [[FileData alloc] init];
    file_name_TF.text       = @"";
    _current_file.fileType  = type;
    
    [file_name_TF becomeFirstResponder];
    
    // start creation of file, dependent on type of file
    if (type == DOCUMENT) {
        [next_button addTarget:self action:@selector(createDocument) forControlEvents:(UIControlEventTouchUpInside)];
        [file_name_TF addTarget:self action:@selector(createDocument) forControlEvents:(UIControlEventEditingDidEnd)];
    } else if (type == PRESENTATION) {
        [next_button addTarget:self action:@selector(createPresentation) forControlEvents:(UIControlEventTouchUpInside)];
        [file_name_TF addTarget:self action:@selector(createPresentation) forControlEvents:(UIControlEventEditingDidEnd)];
    } else if (type == IMAGE) {
        [next_button addTarget:self action:@selector(createImage) forControlEvents:(UIControlEventTouchUpInside)];
        [file_name_TF addTarget:self action:@selector(createImage) forControlEvents:(UIControlEventEditingDidEnd)];
    } else if (type == AUDIO) {
        [next_button addTarget:self action:@selector(createAudio) forControlEvents:(UIControlEventTouchUpInside)];
        [file_name_TF addTarget:self action:@selector(createAudio) forControlEvents:(UIControlEventEditingDidEnd)];
    } else if (type == VIDEO) {
        [next_button addTarget:self action:@selector(createVideo) forControlEvents:(UIControlEventTouchUpInside)];
        [file_name_TF addTarget:self action:@selector(createVideo) forControlEvents:(UIControlEventEditingDidEnd)];
    } else if (type == AUGMENTED_REALITY) {
        [next_button addTarget:self action:@selector(createAR) forControlEvents:(UIControlEventTouchUpInside)];
        [file_name_TF addTarget:self action:@selector(createAR) forControlEvents:(UIControlEventEditingDidEnd)];
    }
}


- (BOOL) isFileNameEmptyOrTaken
{
    [file_name_TF resignFirstResponder];
    // Check to make sure text field is not empty
    if ([file_name_TF.text isEqual:@""])
    {
        error_LBL.text    = @"File name cannot be blank";
        error_LBL.hidden  = NO;
        
        return true;
    }
    
    error_LBL.hidden = YES;
    
    // Check to make sure file name doesnt conflict with another file name within same project
    
    FileData *test = [_current_project fileNamed:file_name_TF.text];
    
    if ([test.fileName isEqualToString:file_name_TF.text]) {
        error_LBL.text    = @"File name taken";
        error_LBL.hidden  = NO;
        return true;
    }
    
    
    
    NSString *name = file_name_TF.text;
    [self hideAll];
    [self saveFileName:name];
    
    
    return false;
}

- (void) saveFileName:(NSString *)name
{
    should_add_file         = true;
    cancel_button.hidden    = NO;
    
    // Store File Name
    _current_file.fileName  = name;
    
}

// File description not necessary (user can skip adding a description)
- (void) changeFileDescription
{
    [self hideAll];
    
    // Unhide necessary objects
    save_button.hidden = NO;
    
    // Create Description Text Field
    CGRect descriptionFrame         = CGRectMake(30, (view_height / 3), (view_width - 60), 200);
    
    create_description_TV                   = [[UITextView alloc] initWithFrame:descriptionFrame];
    create_description_TV.editable          = YES;
    create_description_TV.font              = [UIFont systemFontOfSize:16];
    create_description_TV.backgroundColor   = [UIColor whiteColor];
    
    // Create rectangle around frame of description
    UIView *description_frame           = [[UIView alloc] initWithFrame:CGRectMake(28, (view_height / 3) - 2, (view_width - 56), 204)];
    description_frame.backgroundColor   = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    
    UILabel *descriptionHere = [[UILabel alloc] initWithFrame:CGRectMake(30, (view_height / 3) - 30, 200, 30)];
    descriptionHere.text = @"Add a description below";
    
    [self.view addSubview:description_frame];
    [self.view addSubview:descriptionHere];
    [self.view addSubview:create_description_TV];
    
}

- (void) postComment
{
    post_comment_button.hidden = YES;
    
    if ([edit_description_TV isFirstResponder]) [edit_description_TV resignFirstResponder];
    [_current_file storeDescription:edit_description_TV.text];
    
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
    
    
    take_photo_button                 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    take_photo_button.frame           = CGRectMake((view_width / 2) - 125, (view_height / 3), 250, 50);
    take_photo_button.titleLabel.font = [UIFont systemFontOfSize:30];
    [take_photo_button setTitle:@"Take a Photo" forState:UIControlStateNormal];
    [take_photo_button addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    
    open_camera_roll_button                 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    open_camera_roll_button.frame           = CGRectMake((view_width / 2) - 125, 2 * (view_height / 3), 250, 50);
    open_camera_roll_button.titleLabel.font = [UIFont systemFontOfSize:30];
    [open_camera_roll_button setTitle:@"Open Photo Roll" forState:UIControlStateNormal];
    [open_camera_roll_button addTarget:self action:@selector(openPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:take_photo_button];
    [self.view addSubview:open_camera_roll_button];
    
}

- (void) openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alert_controller = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Device does not have camera" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
        
        [alert_controller addAction:alert];
        
        UIViewController *current_top_VC = [self currentTopViewController];
        [current_top_VC presentViewController:alert_controller animated:YES completion:nil];
        
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
    UIImagePickerController *photo_roll  = [[UIImagePickerController alloc] init];
    photo_roll.allowsEditing             = YES;
    photo_roll.sourceType                = UIImagePickerControllerSourceTypePhotoLibrary;
    photo_roll.delegate                  = self;
    
    [self presentViewController:photo_roll animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *edited_image = info[UIImagePickerControllerEditedImage];
    
    if (edited_image)    [_current_file storeImage:edited_image];
    else                [_current_file storeImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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
    
    if (textField == file_name_TF) {
        
        [textField resignFirstResponder];
    } else if (textField == comment_TF) {
        comment_TF.frame = CGRectMake(10, (view_height - 60), (view_width - 20), 35);
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == comment_TF) {
        
        comment_TF.frame = CGRectMake(10, (keyboard_height + 100), (view_width - 20), 35);
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    post_comment_button                       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    post_comment_button.frame                 = CGRectMake((view_width / 2) - 25, (keyboard_height + 100), 50, 50);
    post_comment_button.titleLabel.textColor  = [UIColor blueColor];
    post_comment_button.titleLabel.font       = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    [post_comment_button setTitle:@"Post" forState:UIControlStateNormal];
    [post_comment_button addTarget:self action:@selector(postComment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:post_comment_button];
    
    if (textView == edit_description_TV) {
        post_comment_button.hidden = NO;
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

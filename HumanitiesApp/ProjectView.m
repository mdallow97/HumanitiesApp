//
//  ProjectView.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/26/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "ProjectView.h"

@interface ProjectView ()

@end

@implementation ProjectView
{
    // General Variable Declaration
    int view_width, view_height;
    
    BOOL should_add_project;
    
    UserData *user_data;
    ProjectData *user_project;
    FilePreView *previews[100];
    
    // Scroll View Variable Declarations
    UIScrollView *files_SV;
    int SV_initial_height, SV_height;
    
    // Cancel Button Variable Declarations
    UIButton *done_button;
    
    // Project Name Label Variable Declaration
    UILabel *project_name_LBL;
    
    // EDITING MODE Variables:
    
    // Add File Button Variable Declaration
    UIButton *editing_options_button;
    
    // Next Button Variable Declaration
    UIButton *next_button;
    
    // Preview Image Options Variable Declaration
    UIViewController *preview_image_options_VC;
    
    
    // NEW PROJECT MODE Variable Declarations:
    
    // New Project Name Text Field
    int TF_width, TF_height;
    UITextField *project_name_TF;
    
    // New Project Name Empty Label
    UILabel *error_LBL;
}

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    
    view_width          = self.view.frame.size.width;
    view_height         = self.view.frame.size.height;
    should_add_project  = false;
    
    // General Text Field Variable Initialization
    TF_width    = 250;
    TF_height   = 50;
    
    // Scroll View Variable Initialization
    SV_initial_height   = 85;
    SV_height           = view_height - SV_initial_height;
    
    user_data    = [UserData sharedMyProjects];
    user_project = [user_data followerProjectWithId:self->_current_project_ID];
    
    if(user_project == nil)
        user_project = [user_data userProjectNamed:self->_current_project_name];
    
    done_button         = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    done_button.frame   = CGRectMake(10, 30, 50, 50);
    [done_button setTitle:@"Done" forState:UIControlStateNormal];
    [done_button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    editing_options_button          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editing_options_button.frame    = CGRectMake(view_width - 55, 30, 50, 50);
    editing_options_button.hidden   = YES;
    [editing_options_button setTitle:@"Edit" forState:UIControlStateNormal];
    [editing_options_button addTarget:self action:@selector(presentEditingOptions) forControlEvents:UIControlEventTouchUpInside];
    
    next_button         = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next_button.frame   = CGRectMake(view_width - 55, 30, 50, 50);
    next_button.hidden  = YES;
    [next_button setTitle:@"Next" forState:UIControlStateNormal];
    [next_button addTarget:self action:@selector(createProject) forControlEvents:UIControlEventTouchUpInside];
    
    project_name_TF                 = [[UITextField alloc] initWithFrame:CGRectMake((view_width / 2) - (TF_width / 2), (view_height / 3), TF_width, TF_height)];
    project_name_TF.borderStyle     = UITextBorderStyleRoundedRect;
    project_name_TF.tintColor       = [UIColor blueColor];
    project_name_TF.backgroundColor = [UIColor lightGrayColor];
    project_name_TF.returnKeyType   = UIReturnKeyDone;
    project_name_TF.textAlignment   = NSTextAlignmentCenter;
    project_name_TF.delegate        = self;
    project_name_TF.hidden          = YES;
    
    
    // Empty Project Name Label Setup
    error_LBL               = [[UILabel alloc] initWithFrame:CGRectMake((view_width / 2) - 125, (view_height / 2), 250, 50)];
    error_LBL.textAlignment = NSTextAlignmentCenter;
    error_LBL.textColor     = [UIColor redColor];
    error_LBL.hidden        = YES;
    
    // Project Name Label Setup
    project_name_LBL                = [[UILabel alloc] initWithFrame:CGRectMake((view_width / 2) - 100, 30, 200, 50)];
    project_name_LBL.textAlignment  = NSTextAlignmentCenter;
    project_name_LBL.text           = _current_project_name;
    
    // Project View Setup
    files_SV                    = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SV_initial_height, view_width, SV_height)];
    files_SV.backgroundColor    = [UIColor whiteColor];
    files_SV.contentSize        = CGSizeMake(view_width, (view_height - 85));
    
    // Adding Subviews
    [self.view addSubview:done_button];
    [self.view addSubview:editing_options_button];
    [self.view addSubview:next_button];
    [self.view addSubview:project_name_TF];
    [self.view addSubview:error_LBL];
    [self.view addSubview:project_name_LBL];
    [self.view addSubview:files_SV];
    
    self.in_editing_mode = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createPreviews];
}

/*
 This function creates all file previews within a project. These previews present a
 preview image for the file. Previews can be tapped on to take the user to the file, where the
 entire file is displayed, and possibly along with a file description added by the owners
 */
- (void) createPreviews
{
    for (UIView *view in files_SV.subviews)
        if ([view isKindOfClass:[FilePreView class]]) [view removeFromSuperview];
    
    NSString *file_IDs      = [self interactWithDatabase:_current_project_ID with: nil at:@"allFile.php"];
    user_project.fileIds    = [self toArray:file_IDs];
    int file_count          = (int) user_project.fileIds.count - 1;
    
    for (int i = 0; i < file_count; i++) {
        FileData *new_file     = [[FileData alloc] init];
        new_file.fileName      = [self interactWithDatabase:user_project.fileIds[i] with:nil at:@"gFileName.php"];
        new_file.fileId = user_project.fileIds[i];
        
        
        if([user_project fileNamed:new_file.fileName] == nil)
            [user_project.files addObject:new_file];
    }
    
    int preview_count = (int) user_project.files.count;
    
    CGRect preview_frame[preview_count];
    int preview_initial_height  = 351;
    int preview_height          = 350;
    
    [self changeScrollHeight:(preview_initial_height * preview_count)];
    
    for (int i = 0; i < preview_count; i++) {
        
        FileData *fd        = (FileData *) user_project.files[i];
        preview_frame[i]    = CGRectMake(0,  (preview_initial_height * i), view_width, preview_height);
        previews[i]         = [[FilePreView alloc] initWithFrame:preview_frame[i]];
        
        [previews[i] setFileName:fd.fileName inProject:user_project withParentView:self];
        [files_SV addSubview: previews[i]];
        
        // File previews can be edited once tapped on, only if project can also be edited
        if (self.in_editing_mode) [previews[i] enterEditingMode];
        
    }
    
}

/*
 This function is used to change the height of the scroll view. This is used everytime a new file is added. This allows the program to change the scroll height dynamically.
 INPUT: height, the new length that the scroll view will be set to
 */
- (void) changeScrollHeight:(int)height
{
    files_SV.contentSize = CGSizeMake(view_width, (height + 30));
}

-(NSMutableArray *) toArray:(NSString *)data
{
    NSArray *items                      = [data componentsSeparatedByString:@" "];
    NSMutableArray* array_of_numbers    = [NSMutableArray arrayWithCapacity:items.count];
    for (NSString* string in items) {
        [array_of_numbers addObject:[NSDecimalNumber decimalNumberWithString:string]];
    }
    
    return array_of_numbers;
}

- (NSString *) interactWithDatabase: (NSString *) projName with: (NSString *) accId at:(NSString *)path
{
    NSString *response;
    NSString *request_string;
    
    // Create your request string with parameter name as defined in PHP file
    request_string                  = [NSString stringWithFormat:@"projName=%@&accId=%@",projName,accId];
    
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
    NSData *return_data = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    
    // Log Response
    response            = [[NSString alloc] initWithBytes:[return_data bytes] length:[return_data length] encoding:NSUTF8StringEncoding];
    
    return response;
}

/*
 This function is called by the doneButton. It is pressed when a user wants to add a project to their account, or dismisses the view controller if it is not owned by the user.
 */
-(void) done
{
    if (should_add_project) {
        [user_data.user_projects addObject:user_project];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (UIViewController *) currentTopViewController
{
    UIViewController *top_VC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (top_VC.presentedViewController)
        top_VC = top_VC.presentedViewController;
    
    return top_VC;
}

- (void) loadProjectWithData:(ProjectData *) project;
{
    _current_project_name     = project.projectName;
    _current_project_ID       = project.projectId;
}



// Functions available only in editing mode

- (void) enterNewProjectMode
{
    next_button.hidden          = NO;
    project_name_TF.hidden      = NO;
    files_SV.hidden             = YES;
    project_name_TF.placeholder = @"New Project Name";
    [project_name_TF becomeFirstResponder];
    
    user_project = [[ProjectData alloc] init];
    
    [done_button setTitle:@"Cancel" forState:UIControlStateNormal];
}

- (void) enterEditingMode
{
    _in_editing_mode                = YES;
    editing_options_button.hidden   = NO;
    files_SV.hidden                 = NO;
}

- (void) createProject
{
    [project_name_TF resignFirstResponder];
    
    // Check to make sure text field is not empty
    if ([project_name_TF.text isEqual:@""])
    {
        error_LBL.text   = @"Project name cannot be blank";
        error_LBL.hidden = NO;
        
        return;
    }
    
    error_LBL.hidden = YES;
    
    // Check to make sure project name doesnt conflict with own project name
    
    user_data = [UserData sharedMyProjects];
    
    ProjectData *pd = [user_data userProjectNamed:project_name_TF.text];
    
    if ([pd.projectName isEqualToString:project_name_TF.text]) {
        error_LBL.text = @"Project name taken";
        error_LBL.hidden = NO;
        return;
    }
    
    should_add_project = true;
    [done_button setTitle:@"Save" forState:UIControlStateNormal];
    
    user_project = [[ProjectData alloc] init];
    
    // Store Project Name
    user_project.projectName    = project_name_TF.text;
    project_name_LBL.text       = project_name_TF.text;
    self->_current_project_name = project_name_TF.text;
    
    error_LBL.hidden        = YES;
    project_name_LBL.hidden = NO;
    next_button.hidden      = YES;
    project_name_TF.hidden  = YES;
    
    NSString *response  = [self interactWithDatabase:user_project.projectName with: user_data.account_ID at:@"setProjId.php"];
    
    
    user_project.projectId = response;
    
    [self enterEditingMode];
}


- (void) presentEditingOptions
{
    
    UIAlertController *editing_options = [UIAlertController alertControllerWithTitle:@"Editing Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete Project" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {[self deleteProject];}];
    
    
    
    UIAlertAction *change_project_name = [UIAlertAction actionWithTitle:@"Change Project Name" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Will present a view controller with text field and appropriate buttons
        // Just need to change _currentProjectName and pd.projectName
        
    }];
    
    UIAlertAction *add_file = [UIAlertAction actionWithTitle:@"Add File" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self addFile];}];
    
    UIAlertAction *change_preview_image = [UIAlertAction actionWithTitle:@"Change Preview Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self changePreviewImage];}];
    
    
    [editing_options addAction:cancel];
    [editing_options addAction:add_file];
    [editing_options addAction:change_project_name];
    [editing_options addAction:change_preview_image];
    
    ProjectData *doesExist = [self->user_data userProjectNamed:self->_current_project_name];
    
    if ([doesExist.projectName isEqualToString:user_project.projectName]) {
        [editing_options addAction:delete];
    }
    
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:editing_options animated:YES completion:nil];
}

- (void) deleteProject
{
    [self->user_data.user_projects removeObject:self->user_project];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) changePreviewImage
{
    
    preview_image_options_VC                        = [[UIViewController alloc] init];
    preview_image_options_VC.view.backgroundColor   = [UIColor whiteColor];
    
    UIButton *take_photo_button       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    take_photo_button.frame           = CGRectMake((view_width / 2) - (TF_width / 2), (view_height / 3), TF_width, TF_height);
    take_photo_button.titleLabel.font = [UIFont systemFontOfSize:30];
    [take_photo_button setTitle:@"Take a Photo" forState:UIControlStateNormal];
    [take_photo_button addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *open_camera_roll_button       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    open_camera_roll_button.frame           = CGRectMake((view_width / 2) - (TF_width / 2), 2 * (view_height / 3), TF_width, TF_height);
    open_camera_roll_button.titleLabel.font = [UIFont systemFontOfSize:30];
    [open_camera_roll_button setTitle:@"Open Photo Roll" forState:UIControlStateNormal];
    [open_camera_roll_button addTarget:self action:@selector(openPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel_button  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancel_button.frame      = CGRectMake(10, 30, 50, 50);
    [cancel_button setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel_button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [preview_image_options_VC.view addSubview:take_photo_button];
    [preview_image_options_VC.view addSubview:open_camera_roll_button];
    [preview_image_options_VC.view addSubview:cancel_button];
    
    [self presentViewController:preview_image_options_VC animated:YES completion:nil];
}

- (void) openCamera
{
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.sourceType               = UIImagePickerControllerSourceTypeCamera;
    camera.delegate                 = self;
    
    [preview_image_options_VC presentViewController:camera animated:YES completion:nil];
}

- (void) openPhotos
{
    UIImagePickerController *photo_roll  = [[UIImagePickerController alloc] init];
    photo_roll.sourceType                = UIImagePickerControllerSourceTypePhotoLibrary;
    photo_roll.delegate                  = self;
    
    [preview_image_options_VC presentViewController:photo_roll animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    user_project.previewImage = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




// File Function Definitions

- (void) addFile
{
    UIAlertController *file_options = [UIAlertController alertControllerWithTitle:@"Choose file type:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *document_action = [UIAlertAction actionWithTitle:@"Document" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:DOCUMENT];}];
    
    UIAlertAction *presentation_action = [UIAlertAction actionWithTitle:@"Presentation" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:PRESENTATION];}];
    
    UIAlertAction *image_action = [UIAlertAction actionWithTitle:@"Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:IMAGE];}];
    
    UIAlertAction *audio_action = [UIAlertAction actionWithTitle:@"Audio" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:AUDIO];}];
    
    UIAlertAction *video_action = [UIAlertAction actionWithTitle:@"Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:VIDEO];}];
    
    UIAlertAction *AR_action = [UIAlertAction actionWithTitle:@"Augmented Reality" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:AUGMENTED_REALITY];}];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    
    [file_options addAction:document_action];
    [file_options addAction:presentation_action];
    [file_options addAction:image_action];
    [file_options addAction:audio_action];
    [file_options addAction:video_action];
    [file_options addAction:AR_action];
    [file_options addAction:cancel];
    
    UIViewController *current_top_VC = [self currentTopViewController];
    [current_top_VC presentViewController:file_options animated:YES completion:nil];
}

- (void) createFileOfType:(int) type
{
    FileView *file_VC = [[FileView alloc] init];
    [file_VC inProject:user_project];
    
    UIViewController *current_top_VC = [self currentTopViewController];
    [current_top_VC presentViewController:file_VC animated:YES completion:nil];
    
    [file_VC createFileOfType:type];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == project_name_TF) {
        [textField resignFirstResponder];
        [self createProject];
    }
    
    return YES;
}




@end

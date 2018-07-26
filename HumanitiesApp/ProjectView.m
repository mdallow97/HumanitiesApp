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
    int viewWidth, viewHeight;
    int buttonWidth, buttonHeight;
    
    BOOL shouldAddProject, shouldAddFile;
    
    UserData *projects;
    ProjectData *projectData;
    FilePreView *previews[100];
    
    // Scroll View Variable Declarations
    UIScrollView *myFilesView;
    int scrollHeightInitial, scrollHeight;
    int scrollWidthInitial, scrollWidth;
    
    // Preview Variable Declarations
    int pvWidthInitial, pvWidth;
    int pvHeightInitial, pvHeight;
    
    // Cancel Button Variable Declarations
    UIButton *doneButton;
    CGRect doneFrame;
    
    // Project Name Label Variable Declaration
    UILabel *projectNameLabel;
    int projectNameWidth, projectNameHeight;
    CGRect projectNameFrame;
    
    // EDITING MODE Variables:
    
    // Add File Button
    UIButton *editingOptionsButton;
    
    int editingOptionsX, editingOptionsY;
    CGRect editingOptionsFrame;
    
    // Next Button
    UIButton *nextButton;
    CGRect nextFrame;
    
    UIViewController *previewOptions;
    
    
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
    
    shouldAddProject    = false;
    shouldAddFile       = false;
    
    buttonWidth         = 50;
    buttonHeight        = 50;
    
    // Preview Variable initialization
    pvWidthInitial      = 0;
    pvHeightInitial     = 351;
    pvHeight            = 350;
    pvWidth             = viewWidth - pvWidthInitial;
    
    // Cancel Button Variable Initialization
    doneFrame           = CGRectMake(10, 30, buttonWidth, buttonHeight);
    
    // Add File Button Variable Initialization
    editingOptionsX     = viewWidth - (buttonWidth + 5);
    editingOptionsY     = 30;
    
    editingOptionsFrame = CGRectMake(editingOptionsX, editingOptionsY, buttonWidth, buttonHeight);
    
    // Next Button Variable Initialization
    nextFrame = editingOptionsFrame;
    
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
    
    // Scroll View Variable initialization
    scrollHeightInitial = 85;
    scrollWidthInitial  = 0;
    scrollWidth         = viewWidth - (2 * scrollWidthInitial);
    scrollHeight        = viewHeight - scrollHeightInitial;
}

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:.902 green:.902 blue:.98 alpha:.99];
    [self frameSetup];
    
    projects    = [UserData sharedMyProjects];
    projectData = [projects projectNamed:self->_currentProjectName]; // Data will be nil if project does not exist
    
    doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    doneButton.frame = doneFrame;
    
    editingOptionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editingOptionsButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editingOptionsButton addTarget:self action:@selector(showEditingOptions) forControlEvents:UIControlEventTouchUpInside];
    editingOptionsButton.frame  = editingOptionsFrame;
    editingOptionsButton.hidden = YES;
    
    nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(createProject) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame  = nextFrame;
    nextButton.hidden = YES;
    
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake((viewWidth / 2) - (textFieldWidth / 2), (viewHeight / 3), textFieldWidth, textFieldHeight)];
    nameTextField.borderStyle     = UITextBorderStyleRoundedRect;
    nameTextField.tintColor       = [UIColor blueColor];
    nameTextField.backgroundColor = [UIColor lightGrayColor];
    nameTextField.returnKeyType   = UIReturnKeyDone;
    nameTextField.textAlignment   = NSTextAlignmentCenter;
    nameTextField.delegate        = self;
    nameTextField.hidden          = YES;
    
    
    // Empty Project Name Label Setup
    errorFieldLabel               = [[UILabel alloc] initWithFrame:errorFieldFrame];
    errorFieldLabel.textAlignment = NSTextAlignmentCenter;
    errorFieldLabel.textColor     = [UIColor redColor];
    errorFieldLabel.hidden        = YES;
    
    // Project Name Label Setup
    projectNameLabel = [[UILabel alloc] initWithFrame:projectNameFrame];
    projectNameLabel.textAlignment = NSTextAlignmentCenter;
    projectNameLabel.text = _currentProjectName;
    
    // Project View Setup
    myFilesView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollWidthInitial, scrollHeightInitial, scrollWidth, scrollHeight)];
    myFilesView.backgroundColor = [UIColor whiteColor];
    myFilesView.contentSize     = CGSizeMake(viewWidth, (viewHeight - 85));
    
    // Adding Subviews
    [self.view addSubview:doneButton];
    [self.view addSubview:editingOptionsButton];
    [self.view addSubview:nextButton];
    [self.view addSubview:nameTextField];
    [self.view addSubview:errorFieldLabel];
    [self.view addSubview:projectNameLabel];
    [self.view addSubview:myFilesView];
    
    self.inEditingMode = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createPreviews];
}

- (void) createPreviews
{
    for (UIView *view in myFilesView.subviews)
        if ([view isKindOfClass:[FilePreView class]]) [view removeFromSuperview];
    
    
    int numberOfPreviews = (int) projectData.files.count;
    
    CGRect rect[numberOfPreviews];
    
    [self changeScrollHeight:(pvHeightInitial * numberOfPreviews)];
    
    int i;
    
    for (i = 0; i < numberOfPreviews; i++) {
        
        FileData *fd = (FileData *) projectData.files[i];
        
        rect[i]         = CGRectMake(pvWidthInitial,  (pvHeightInitial * i), pvWidth, pvHeight);
        previews[i]     = [[FilePreView alloc] initWithFrame:rect[i]];
        
        [previews[i] setFileName:fd.fileName inProject:projectData withParentView:self];
        [myFilesView addSubview: previews[i]];
        
        // File previews can be edited once tapped on, only if project can also be edited
        if (self.inEditingMode) [previews[i] enterEditingMode];
        
    }
    
}

- (void) changeScrollHeight:(int)height
{
    myFilesView.contentSize = CGSizeMake(viewWidth, height);
}


-(void) done
{
    if (shouldAddProject) {
        [projects.myProjects addObject:projectData];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *) currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (topVC.presentedViewController)
        topVC = topVC.presentedViewController;
    
    return topVC;
}

- (void) loadProjectWithData:(ProjectData *) project;
{
    _currentProjectName     = project.projectName;
}



// Functions available only in editing mode

- (void) enterNewProjectMode
{
    nextButton.hidden           = NO;
    nameTextField.hidden        = NO;
    myFilesView.hidden          = YES;
    nameTextField.placeholder   = @"New Project Name";
    [nameTextField becomeFirstResponder];
    
    projectData = [[ProjectData alloc] init];
    
    [doneButton setTitle:@"Cancel" forState:UIControlStateNormal];
}

- (void) enterEditingMode
{
    self.inEditingMode          = YES;
    editingOptionsButton.hidden = NO;
    myFilesView.hidden          = NO;
}

- (void) createProject
{
    [nameTextField resignFirstResponder];
    
    // Check to make sure text field is not empty
    if ([nameTextField.text isEqual:@""])
    {
        errorFieldLabel.text   = @"Project name cannot be blank";
        errorFieldLabel.hidden = NO;
        
        return;
    }
    
    errorFieldLabel.hidden = YES;
    
    // Check to make sure project name doesnt conflict with own project name
    
    projects = [UserData sharedMyProjects];
    
    ProjectData *pd = [projects projectNamed:nameTextField.text];
    
    if ([pd.projectName isEqualToString:nameTextField.text]) {
        errorFieldLabel.text = @"Project name taken";
        errorFieldLabel.hidden = NO;
        return;
    }
    
    
    
    shouldAddProject = true;
    [doneButton setTitle:@"Save" forState:UIControlStateNormal];
    
    projectData = [[ProjectData alloc] init];
    
    // Store Project Name
    projectData.projectName   = nameTextField.text;
    projectNameLabel.text     = nameTextField.text;
    self->_currentProjectName = nameTextField.text;
    
    errorFieldLabel.hidden  = YES;
    projectNameLabel.hidden = NO;
    nextButton.hidden       = YES;
    nameTextField.hidden    = YES;
    
    [self enterEditingMode];
}


- (void) showEditingOptions
{
    
    UIAlertController *editOptions = [UIAlertController alertControllerWithTitle:@"Editing Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete Project" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {[self deleteProject];}];
    
    
    
    UIAlertAction *changeName = [UIAlertAction actionWithTitle:@"Change Project Name" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Will present a view controller with text field and appropriate buttons
        // Just need to change _currentProjectName and pd.projectName
        
    }];
    
    UIAlertAction *addFile = [UIAlertAction actionWithTitle:@"Add File" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self addFile];}];
    
    UIAlertAction *changePreview = [UIAlertAction actionWithTitle:@"Change Preview Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self changePreviewImage];}];
    
    
    [editOptions addAction:cancel];
    [editOptions addAction:addFile];
    [editOptions addAction:changeName];
    [editOptions addAction:changePreview];
    
    ProjectData *doesExist = [self->projects projectNamed:self->_currentProjectName];
    
    if ([doesExist.projectName isEqualToString:projectData.projectName]) {
        [editOptions addAction:delete];
    }
    
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:editOptions animated:YES completion:nil];
}

- (void) deleteProject
{
    [self->projects.myProjects removeObject:self->projectData];
    
    // *** Have a fail safe delete in case of accidental removal
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) changePreviewImage
{
    
    previewOptions = [[UIViewController alloc] init];
    previewOptions.view.backgroundColor = [UIColor whiteColor];
    
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
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = doneFrame;
    
    [previewOptions.view addSubview:takePhotoButton];
    [previewOptions.view addSubview:openPhotosButton];
    [previewOptions.view addSubview:cancelButton];
    
    [self presentViewController:previewOptions animated:YES completion:nil];
}

- (void) openCamera
{
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.sourceType               = UIImagePickerControllerSourceTypeCamera;
    camera.delegate                 = self;
    
    [previewOptions presentViewController:camera animated:YES completion:nil];
}

- (void) openPhotos
{
    UIImagePickerController *photoRoll  = [[UIImagePickerController alloc] init];
    photoRoll.sourceType                = UIImagePickerControllerSourceTypePhotoLibrary;
    photoRoll.delegate                  = self;
    
    [previewOptions presentViewController:photoRoll animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    projectData.previewImage = image;
    
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
    UIAlertController *fileOptions = [UIAlertController alertControllerWithTitle:@"Choose file type:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *docAction = [UIAlertAction actionWithTitle:@"Document" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:DOCUMENT];}];
    
    UIAlertAction *presentationAction = [UIAlertAction actionWithTitle:@"Presentation" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:PRESENTATION];}];
    
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:IMAGE];}];
    
    UIAlertAction *audioAction = [UIAlertAction actionWithTitle:@"Audio" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:AUDIO];}];
    
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:VIDEO];}];
    
    UIAlertAction *arAction = [UIAlertAction actionWithTitle:@"Augmented Reality" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self createFileOfType:AUGMENTED_REALITY];}];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    
    [fileOptions addAction:docAction];
    [fileOptions addAction:presentationAction];
    [fileOptions addAction:imageAction];
    [fileOptions addAction:audioAction];
    [fileOptions addAction:videoAction];
    [fileOptions addAction:arAction];
    [fileOptions addAction:cancel];
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:fileOptions animated:YES completion:nil];
}

- (void) createFileOfType:(int) type
{
    FileView *fileViewController = [[FileView alloc] init];
    [fileViewController inProject:projectData];
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:fileViewController animated:YES completion:nil];
    
    [fileViewController createFileOfType:type];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == nameTextField) {
        [textField resignFirstResponder];
        [self createProject];
    }
    
    return YES;
}




@end

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
    
    // Scroll View Variable Declarations
    UIScrollView *myFilesView;
    int scrollHeightInitial, scrollHeight;
    int scrollWidthInitial, scrollWidth;
    
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
    projectNameLabel.hidden        = YES;
    
    // Project View Setup
    myFilesView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollWidthInitial, scrollHeightInitial, scrollWidth, scrollHeight)];
    myFilesView.backgroundColor = [UIColor whiteColor];
    myFilesView.contentSize     = CGSizeMake(viewWidth, (viewHeight - 85));
    myFilesView.hidden          = YES;
    
    // Adding Subviews
    [self.view addSubview:doneButton];
    [self.view addSubview:editingOptionsButton];
    [self.view addSubview:nextButton];
    [self.view addSubview:nameTextField];
    [self.view addSubview:errorFieldLabel];
    [self.view addSubview:projectNameLabel];
    [self.view addSubview:myFilesView];
}

- (void) showEditingOptions
{
    
    UIAlertController *editOptions = [UIAlertController alertControllerWithTitle:@"Editing Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete Project" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self deleteProject];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
    
    UIAlertAction *changeName = [UIAlertAction actionWithTitle:@"Change Project Name" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Will present a view controller with text field and appropriate buttons
        // Just need to change _currentProjectName and pd.projectName
        
    }];
    
    UIAlertAction *addFile = [UIAlertAction actionWithTitle:@"Add File" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self addFile];}];
    
    UIAlertAction *removeFile = [UIAlertAction actionWithTitle:@"Remove File" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Will remove a file, may have to move this action into the file view itself
        // Otherwise, will have to have user pick which file to delete
        
    }];
    
    
    [editOptions addAction:cancel];
    [editOptions addAction:addFile];
    [editOptions addAction:removeFile];
    [editOptions addAction:changeName];
    
    ProjectData *doesExist = [self->projects projectNamed:self->_currentProjectName];
    
    if ([doesExist.projectName isEqualToString:projectData.projectName]) {
        [editOptions addAction:delete];
    }
    
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:editOptions animated:YES completion:nil];
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



// Project Function Definitions

- (void) loadProjectWithData:(ProjectData *) project;
{
    _currentProjectName = project.projectName;
}

- (void) enterNewProjectMode
{
    nextButton.hidden    = NO;
    nameTextField.hidden = NO;
    nameTextField.placeholder = @"New Project Name";
    
    [doneButton setTitle:@"Cancel" forState:UIControlStateNormal];
}

- (void) createProject
{
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

- (void) enterEditingMode
{
    editingOptionsButton.hidden = NO;
    myFilesView.hidden          = NO;
}

- (void) deleteProject
{
    [self->projects.myProjects removeObject:self->projectData];
    
    // *** Have a fail safe delete in case of accidental removal
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




@end

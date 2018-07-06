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
    
    BOOL shouldAdd;
    
    MyProjects *projects;
    ProjectData *data;
    
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
    UITextField *projectNameTextField;
    
    // New Project Name Empty Label
    UILabel *errorFieldLabel;
    int errorFieldWidth, errorFieldHeight;
    CGRect errorFieldFrame;
}

- (void) frameSetup
{
    // General Variable Initialization
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    
    shouldAdd = false;
    
    buttonWidth = 50;
    buttonHeight = 50;
    
    // Cancel Button Variable Initialization
    doneFrame = CGRectMake(10, 30, buttonWidth, buttonHeight);
    
    // Add File Button Variable Initialization
    editingOptionsX = viewWidth - (buttonWidth + 5);
    editingOptionsY = 30;
    
    editingOptionsFrame = CGRectMake(editingOptionsX, editingOptionsY, buttonWidth, buttonHeight);
    
    // Next Button Variable Initialization
    nextFrame = editingOptionsFrame;
    
    // General Text Field Variable Initialization
    textFieldWidth = 250;
    textFieldHeight = 50;
    
    // Empty Name Label Variable Initialization
    errorFieldWidth = 250;
    errorFieldHeight = 50;
    errorFieldFrame = CGRectMake((viewWidth / 2) - (errorFieldWidth / 2), (viewHeight / 2), errorFieldWidth, errorFieldHeight);
    
    // Project Name Label Variable Initialization
    projectNameWidth = 200;
    projectNameHeight = 50;
    projectNameFrame = CGRectMake((viewWidth / 2) - (projectNameWidth / 2), 30, projectNameWidth, projectNameHeight);
}

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self frameSetup];
    
    doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton setTitle:@"Cancel" forState:UIControlStateNormal];
    doneButton.frame = doneFrame;
    [doneButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    editingOptionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editingOptionsButton setTitle:@"Edit" forState:UIControlStateNormal];
    editingOptionsButton.frame = editingOptionsFrame;
    editingOptionsButton.hidden = YES;
    [editingOptionsButton addTarget:self action:@selector(showEditingOptions) forControlEvents:UIControlEventTouchUpInside];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextButton.frame = nextFrame;
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    nextButton.hidden = YES;
    [nextButton addTarget:self action:@selector(createProject) forControlEvents:UIControlEventTouchUpInside];
    
    projectNameTextField = [[UITextField alloc] initWithFrame:CGRectMake((viewWidth / 2) - (textFieldWidth / 2), (viewHeight / 3), textFieldWidth, textFieldHeight)];
    projectNameTextField.hidden = YES;
    projectNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    projectNameTextField.tintColor = [UIColor blueColor];
    projectNameTextField.backgroundColor = [UIColor lightGrayColor];
    projectNameTextField.placeholder = @"New Project Name";
    projectNameTextField.returnKeyType = UIReturnKeyDone;
    projectNameTextField.textAlignment = NSTextAlignmentCenter;
    projectNameTextField.delegate = self;
    
    
    // Empty Project Name Label Setup
    errorFieldLabel = [[UILabel alloc] initWithFrame:errorFieldFrame];
    errorFieldLabel.textAlignment = NSTextAlignmentCenter;
    errorFieldLabel.hidden = YES;
    errorFieldLabel.textColor = [UIColor redColor];
    
    // Project Name Label Setup
    projectNameLabel = [[UILabel alloc] initWithFrame:projectNameFrame];
    projectNameLabel.hidden = YES;
    projectNameLabel.textAlignment = NSTextAlignmentCenter;
    
    // Adding Subviews
    [self.view addSubview:doneButton];
    [self.view addSubview:editingOptionsButton];
    [self.view addSubview:nextButton];
    [self.view addSubview:projectNameTextField];
    [self.view addSubview:errorFieldLabel];
    [self.view addSubview:projectNameLabel];
}

- (void) showEditingOptions
{
    
    UIAlertController *editOptions = [UIAlertController alertControllerWithTitle:@"Editing Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Add File" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        
    }];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete Project" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        MyProjects *projects = [MyProjects sharedMyProjects];
        int numProjects = (int) projects.myProjects.count;
        int i, indexOfRemoval = 0;
        
        for (i = 0; i < numProjects; i++) {
            ProjectData *pd = (ProjectData *) projects.myProjects[i];
            
            if (pd.projectName == self->_currentProjectName) {
                indexOfRemoval = i;
                break;
            }
        }
        
        
        // *** Have a fail safe delete in case of accidental removal
        [projects.myProjects removeObjectAtIndex:indexOfRemoval];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
    [editOptions addAction:cancel];
    [editOptions addAction:delete];
    [editOptions addAction:edit];
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:editOptions animated:YES completion:nil];
}

- (void) enterNewProjectMode
{
    nextButton.hidden = NO;
    projectNameTextField.hidden = NO;
}

- (void) createProject
{
    // Check to make sure text field is not empty
    if ([projectNameTextField.text isEqual:@""])
    {
        errorFieldLabel.text = @"Project name cannot be blank";
        errorFieldLabel.hidden = NO;
        
        return;
    }
    
    errorFieldLabel.hidden = YES;
    
    // Check to make sure project name doesnt conflict with own project name
    projects = [MyProjects sharedMyProjects];
    int i;
    
    for (i = 0; i < projects.myProjects.count; i++) {
        
        ProjectData *pd = (ProjectData *) projects.myProjects[i];
        
        if ([pd.projectName isEqualToString:projectNameTextField.text]) {
            errorFieldLabel.text = @"Project name taken";
            errorFieldLabel.hidden = NO;
            return;
        }

    }
    
    shouldAdd = true;
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    data = [[ProjectData alloc] init];
    
    // Store Project Name
    data.projectName = projectNameTextField.text;
    projectNameLabel.text = projectNameTextField.text;
    self->_currentProjectName = projectNameTextField.text;
    
    errorFieldLabel.hidden = YES;
    projectNameLabel.hidden = NO;
    
    
    nextButton.hidden = YES;
    projectNameTextField.hidden = YES;
    
    // Code to save a new blank project with given name
    
    // ...
    
    [self enterEditingMode];
}

- (void) enterEditingMode
{
    editingOptionsButton.hidden = NO;
}

-(void) cancel
{
    if (shouldAdd) {
        [projects.myProjects addObject:data];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadProjectWithData:(ProjectData *) project;
{
    _currentProjectName = project.projectName;
}

- (UIViewController *) currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (topVC.presentedViewController)
        topVC = topVC.presentedViewController;
    
    return topVC;
}



@end

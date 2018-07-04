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
    
    // Cancel Button Variable Declarations
    UIButton *cancelButton;
    CGRect cancelFrame;
    
    // Project Name Label Variable Declaration
    UILabel *projectNameLabel;
    int projectNameWidth, projectNameHeight;
    CGRect projectNameFrame;
    
    // EDITING MODE Variables:
    
    // Add File Button
    UIButton *addFileButton;
    
    int addFileX, addFileY;
    CGRect addFileFrame;
    
    // Next Button
    UIButton *nextButton;
    CGRect nextFrame;
    
    
    // NEW PROJECT MODE Variable Declarations:
    
    // New Project Name Text Field
    int textFieldWidth, textFieldHeight;
    UITextField *projectNameTextField;
    
    // New Project Name Empty Label
    UILabel *emptyFieldLabel;
    int emptyFieldWidth, emptyFieldHeight;
    CGRect emptyFieldFrame;
}

- (void) setup
{
    // General Variable Initialization
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    
    buttonWidth = 50;
    buttonHeight = 50;
    
    // Cancel Button Variable Initialization
    cancelFrame = CGRectMake(10, 30, buttonWidth, buttonHeight);
    
    // Add File Button Variable Initialization
    addFileX = viewWidth - (buttonWidth + 5);
    addFileY = 30;
    
    addFileFrame = CGRectMake(addFileX, addFileY, buttonWidth, buttonHeight);
    
    // Next Button Variable Initialization
    nextFrame = addFileFrame;
    
    // General Text Field Variable Initialization
    textFieldWidth = 250;
    textFieldHeight = 50;
    
    // Empty Name Label Variable Initialization
    emptyFieldWidth = 250;
    emptyFieldHeight = 50;
    emptyFieldFrame = CGRectMake((viewWidth / 2) - (emptyFieldWidth / 2), (viewHeight / 2), emptyFieldWidth, emptyFieldHeight);
    
    // Project Name Label Variable Initialization
    projectNameWidth = 200;
    projectNameHeight = 30;
    projectNameFrame = CGRectMake((viewWidth / 2) - (projectNameWidth / 2), 30, projectNameWidth, projectNameHeight);
}

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.frame = cancelFrame;
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    addFileButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addFileButton.frame = addFileFrame;
    addFileButton.hidden = YES;
    [addFileButton addTarget:self action:@selector(addFile) forControlEvents:UIControlEventTouchUpInside];
    
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
    emptyFieldLabel = [[UILabel alloc] initWithFrame:emptyFieldFrame];
    emptyFieldLabel.hidden = YES;
    emptyFieldLabel.text = @"Project name cannot be blank";
    emptyFieldLabel.textColor = [UIColor redColor];
    
    // Project Name Label Setup
    projectNameLabel = [[UILabel alloc] initWithFrame:projectNameFrame];
    projectNameLabel.hidden = YES;
    projectNameLabel.textAlignment = NSTextAlignmentCenter;
    
    // Adding Subviews
    [self.view addSubview:cancelButton];
    [self.view addSubview:addFileButton];
    [self.view addSubview:nextButton];
    [self.view addSubview:projectNameTextField];
    [self.view addSubview:emptyFieldLabel];
    [self.view addSubview:projectNameLabel];
}

- (void) addFile
{
    NSLog(@"Will add a file\n");
}

- (void) enterNewProjectMode
{
    nextButton.hidden = NO;
    projectNameTextField.hidden = NO;
}

- (void) createProject
{
    // Must check to make sure text field is not empty !!!
    
    if ([projectNameTextField.text isEqual:@""])
    {
        
        emptyFieldLabel.hidden = NO;
        
        return;
    }
    
    projectNameLabel.text = projectNameTextField.text;
    
    emptyFieldLabel.hidden = YES;
    projectNameLabel.hidden = NO;
    
    
    // Save new project with name stored in projectNameTextField.text into ProjectData
    
    nextButton.hidden = YES;
    projectNameTextField.hidden = YES;
    
    // Code to save a new blank project with given name
    
    // ...
    
    [self enterEditingMode];
}

- (void) enterEditingMode
{
    addFileButton.hidden = NO;
}

-(void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

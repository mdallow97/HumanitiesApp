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
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    
    shouldAddFile = false;
    
    buttonWidth = 50;
    buttonHeight = 50;
    
    // Cancel Button Variable Initialization
    cancelFrame = CGRectMake(10, 30, buttonWidth, buttonHeight);
    
    // Add File Button Variable Initialization
    cancelX = viewWidth - (buttonWidth + 5);
    cancelY = 30;
    
    saveFrame = CGRectMake(cancelX, cancelY, buttonWidth, buttonHeight);
    
    // Next Button Variable Initialization
    nextFrame = saveFrame;
    
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
    
    saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.hidden = YES;
    saveButton.frame = saveFrame;
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.frame = cancelFrame;
    cancelButton.hidden = YES;
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextButton.frame = nextFrame;
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    nextButton.hidden = YES;
    // nextButton target is dependent on file type
    
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake((viewWidth / 2) - (textFieldWidth / 2), (viewHeight / 3), textFieldWidth, textFieldHeight)];
    self->nameTextField.placeholder = @"New File Name";
    nameTextField.hidden = YES;
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.tintColor = [UIColor blueColor];
    nameTextField.backgroundColor = [UIColor lightGrayColor];
    nameTextField.returnKeyType = UIReturnKeyDone;
    nameTextField.textAlignment = NSTextAlignmentCenter;
    nameTextField.delegate = self;
    
    
    // Empty Project Name Label Setup
    errorFieldLabel = [[UILabel alloc] initWithFrame:errorFieldFrame];
    errorFieldLabel.textAlignment = NSTextAlignmentCenter;
    errorFieldLabel.hidden = YES;
    errorFieldLabel.textColor = [UIColor redColor];
    
    [self hideAll];
    
    // Adding Subviews
    [self.view addSubview:saveButton];
    [self.view addSubview:cancelButton];
    [self.view addSubview:nextButton];
    [self.view addSubview:nameTextField];
    [self.view addSubview:errorFieldLabel];
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
    saveButton.hidden = YES;
    cancelButton.hidden = YES;
    nextButton.hidden = YES;
    nameTextField.hidden = YES;
    errorFieldLabel.hidden = YES;
}





- (void) createFileOfType:(int) type
{
    [self hideAll];
    cancelButton.hidden        = NO;
    nextButton.hidden    = NO;
    nameTextField.hidden = NO;
    
    nameTextField.text = @"";
    
    if (type == DOCUMENT) [nextButton addTarget:self action:@selector(createDocument) forControlEvents:(UIControlEventTouchUpInside)];
    else if (type == PRESENTATION) [nextButton addTarget:self action:@selector(createPresentation) forControlEvents:(UIControlEventTouchUpInside)];
    else if (type == IMAGE) [nextButton addTarget:self action:@selector(createImage) forControlEvents:(UIControlEventTouchUpInside)];
    else if (type == AUDIO) [nextButton addTarget:self action:@selector(createAudio) forControlEvents:(UIControlEventTouchUpInside)];
    else if (type == VIDEO) [nextButton addTarget:self action:@selector(createVideo) forControlEvents:(UIControlEventTouchUpInside)];
    else if (type == AUGMENTED_REALITY) [nextButton addTarget:self action:@selector(createAR) forControlEvents:(UIControlEventTouchUpInside)];
}


- (BOOL) isFileNameEmptyOrTaken
{
    // Check to make sure text field is not empty
    if ([nameTextField.text isEqual:@""])
    {
        errorFieldLabel.text = @"File name cannot be blank";
        errorFieldLabel.hidden = NO;
        
        return true;
    }
    
    errorFieldLabel.hidden = YES;
    
    // Check to make sure file name doesnt conflict with another file name within same project
    
    fileData = [projectData fileNamed:nameTextField.text];
    
    if ([fileData.fileName isEqualToString:nameTextField.text]) {
        errorFieldLabel.text = @"File name taken";
        errorFieldLabel.hidden = NO;
        return true;
    }
    
    
    
    NSString *name = nameTextField.text;
    [self hideAll];
    [self saveFileWithName:name];
    
    
    return false;
}

- (void) saveFileWithName:(NSString *)name
{
    shouldAddFile = true;
    
    saveButton.hidden = NO;
    
    fileData = [[FileData alloc] init];
    
    // Store File Name
    fileData.fileName = name;
    
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

@end

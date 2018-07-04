//
//  LogInViewController.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/27/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef LogInViewController_h
#define LogInViewController_h

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface LogInViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) NSString *username;

- (BOOL) logIn;

@end


#endif /* LogInViewController_h */

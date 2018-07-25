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
#import "AppDelegate.h"


@interface LogInViewController : UIViewController <UITextFieldDelegate, UITabBarDelegate>
{
    BOOL finished;
}
@property (nonatomic, retain) NSString *username;

-(BOOL) registerNow;
- (void) hasParent: (UIResponder *) parent;
- (BOOL) logIn;
//-(BOOL) createRegistration;


@end


#endif /* LogInViewController_h */

//
//  UserData.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/2/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef UserData_h
#define UserData_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProjectData.h"

@interface UserData : NSObject

// User Data
@property NSString *username;
@property NSString *password;
@property NSString *accId;

+ (id) globalUserData;


// Project Data
@property (nonatomic, retain) NSMutableArray *myProjects;

+ (id) sharedMyProjects;

// Commented part of below function will allow us to find unique project
- (ProjectData *) projectNamed: (NSString *) name; //byUser: (NSString *) username;



@end


#endif /* UserData_h */

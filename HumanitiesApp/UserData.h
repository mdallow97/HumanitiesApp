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
@property NSString *account_ID;


// Project Data
@property (nonatomic, retain) NSMutableArray *user_projects;
@property (nonatomic, retain) NSMutableArray *project_IDs;


// Follower Project Data
@property (nonatomic, retain) NSMutableArray *followers;
@property (nonatomic, retain) NSMutableArray *follower_projects;
@property (nonatomic, retain) NSMutableArray *follower_project_IDs;
@property (nonatomic, retain) NSMutableArray *follower_project_names;

+ (id) sharedMyProjects;

// Commented part of below function will allow us to find unique project
- (ProjectData *) userProjectNamed: (NSString *) name;
- (ProjectData *) followerProjectWithId: (NSString *) Id;



@end


#endif /* UserData_h */

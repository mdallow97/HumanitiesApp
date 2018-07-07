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

@interface UserData : NSObject

// User Data
@property NSString *username;
@property NSString *password;

+ (id) globalUserData;


// Project Data
@property (nonatomic, retain) NSMutableArray *myProjects;

+ (id) sharedMyProjects;



@end


#endif /* UserData_h */

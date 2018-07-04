//
//  MyProjects.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/3/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef MyProjects_h
#define MyProjects_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyProjects : NSObject

@property (nonatomic, retain) NSMutableArray *myProjects;

+ (id) sharedMyProjects;

@end


#endif /* MyProjects_h */

//
//  CommentData.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 9/21/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef CommentData_h
#define CommentData_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommentData : NSObject

@property NSString *commentContent;
@property NSString *user; // may have to be type UserData rather than a string
@property unsigned date; // Format: MonthDayYear -> January 1, 2001 is 01012001
@property unsigned time; // Format: Military Time -> 4pm is 1600




@end

#endif /* CommentData_h */

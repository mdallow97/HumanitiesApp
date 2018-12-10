//
//  ProjectData.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/3/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef ProjectData_h
#define ProjectData_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FileData.h"

@interface ProjectData : NSObject

@property NSString *projectId;
@property NSString *projectName;
@property UIImage *previewImage;
@property (nonatomic, retain) NSMutableArray *fileIds;

@property (nonatomic, retain) NSMutableArray *files;

+ (id) sharedFiles;
- (FileData *) fileNamed:(NSString *)name;

@end

#endif /* ProjectData_h */

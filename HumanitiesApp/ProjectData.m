//
//  ProjectData.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/3/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectData.h"

@implementation ProjectData

+ (id) sharedFiles {
    static ProjectData *files = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        files = [[self alloc] init];
    });
    return files;
}

- (id) init {
    if (self = [super init]) {
        self.files = [[NSMutableArray alloc] init];
    }
    return self;
}

- (FileData *) fileNamed:(NSString *)name
{
    FileData *fd = nil;
    
    int numProjects = (int) self.files.count;
    int i;
    
    for (i = 0; i < numProjects; i++) {
        FileData *test = (FileData *) self.files[i];
        
        if (fd.fileName == name) {
            fd = test;
            break;
        }
    }
    
    return fd;
}


@end

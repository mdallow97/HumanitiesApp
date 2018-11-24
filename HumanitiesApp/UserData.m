//
//  UserData.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/2/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "UserData.h"

@implementation UserData


+ (id) sharedMyProjects {
    static UserData *projects = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        projects = [[self alloc] init];
    });
    return projects;
}

- (id) init {
    if (self = [super init]) {
        self.myProjects = [[NSMutableArray alloc] init];
    }
    return self;
}

// returns a project with given "name". Searches through every project
- (ProjectData *) projectNamed:(NSString *)name
{
    ProjectData *pd = nil;
    
    
    int numProjects = (int) self.myProjects.count;
    int i;
    
    for (i = 0; i < numProjects; i++) {
        ProjectData *test = (ProjectData *) self.myProjects[i];
        
        if ([test.projectName isEqualToString:name]) {
            
            pd = test;
            
            break;
        }
    }
    
    // Double check
    if (![pd.projectName isEqualToString:name]) return nil;
    else return pd;
}


@end

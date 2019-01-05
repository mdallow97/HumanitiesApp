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
        self.user_projects = [[NSMutableArray alloc] init];
        self.follower_projects = [[NSMutableArray alloc] init];
    }
    return self;
}

// returns a project with given "name". Searches through every project
- (ProjectData *) userProjectNamed:(NSString *)name
{
    ProjectData *pd = nil;
    
    
    int numProjects = (int) self.user_projects.count;
    int i;
    
    for (i = 0; i < numProjects; i++) {
        ProjectData *test = (ProjectData *) self.user_projects[i];
        
        if ([test.projectName isEqualToString:name]) {
            
            pd = test;
            
            break;
        }
    }
    
    // Double check
    if (![pd.projectName isEqualToString:name]) return nil;
    else return pd;
}

- (ProjectData *) followerProjectWithId: (NSString *) pId
{
    ProjectData *pd = nil;
    
    
    int numProjects = (int) self.follower_projects.count;
    int i;
    
    for (i = 0; i < numProjects; i++) {
        ProjectData *test = (ProjectData *) self.follower_projects[i];

        if ([(NSString *) test.projectId isEqual: (NSString *)pId]) {
            pd = test;
            
            break;
        }
    }

    // Double check
    if (![(NSString *) pd.projectId isEqual:(NSString *) pId]) return nil;
    else return pd;
}


@end

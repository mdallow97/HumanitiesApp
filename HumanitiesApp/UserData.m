//
//  UserData.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/2/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "UserData.h"

@implementation UserData

+ (id) globalUserData {
    static UserData *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[self alloc] init];
    });
    return data;
}

+ (id) sharedMyProjects {
    static UserData *projects = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        projects = [[self alloc] init];
    });
    return projects;
}

- (id)init {
    if (self = [super init]) {
        self.myProjects = [[NSMutableArray alloc] init];
    }
    return self;
}


@end

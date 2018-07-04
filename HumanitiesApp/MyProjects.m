//
//  MyProjects.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/3/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "MyProjects.h"

@implementation MyProjects

+ (id)sharedMyProjects {
    static MyProjects *projects = nil;
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

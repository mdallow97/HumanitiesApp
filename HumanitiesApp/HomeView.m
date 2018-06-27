//
//  HomeView.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 6/25/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "HomeView.h"

@interface HomeView ()

@end

@implementation HomeView
{
    ProjectView *pv;
    CGRect rect;
    int viewWidth, viewHeight;
    int pvWidthInitial, pvWidth;
    int pvHeightInitial, pvHeight;
}

- (void) setup
{
    viewWidth = self.frame.size.width;
    viewHeight = self.frame.size.height;
    pvWidthInitial = 0;
    pvHeightInitial = 10;
    pvHeight = 350;
    pvWidth = viewWidth - pvWidthInitial;
    
    
    rect = CGRectMake(pvWidthInitial, pvHeightInitial, pvWidth, pvHeight);
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setup];
    
    pv = [[ProjectView alloc] initWithFrame:rect];
    [self addSubview: pv];

    pv.backgroundColor = [UIColor grayColor];
    [pv setNeedsDisplay];
//    CGFloat y;
//
//    int i;
//    for (i = 0; i < 4; i++) {
//        y = i * (viewHeight / 4);
//        NSLog(@"%f\n", y);
//        rect = [self setup:y];
//        pv = [[ProjectView alloc] initWithFrame:rect];
//
//        pv.backgroundColor = [UIColor grayColor];
//        [self addSubview:pv];
//    }
    
    self.contentSize = CGSizeMake(viewWidth, viewHeight);
    
    
    return self;
}


@end

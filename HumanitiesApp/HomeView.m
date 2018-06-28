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
    PreView *pv[3];
    CGRect rect[3];
    int viewWidth, viewHeight;
    int pvWidthInitial, pvWidth;
    int pvHeightInitial, pvHeight;
    int scrollHeight;
}

- (void) setup
{
    scrollHeight = 4000;
    viewWidth = self.frame.size.width;
    viewHeight = self.frame.size.height;
    
    self.contentSize = CGSizeMake(viewWidth, scrollHeight);
    
    
    pvWidthInitial = 0;
    pvHeightInitial = 351;
    pvHeight = 350;
    pvWidth = viewWidth - pvWidthInitial;
    
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setup];
    
    self.backgroundColor = [UIColor blackColor];
    
    int i;
    for (i = 0; i < 4; i ++)
    {
        rect[i] = CGRectMake(pvWidthInitial,  (pvHeightInitial * i), pvWidth, pvHeight);
        
        pv[i] = [[PreView alloc] initWithFrame:rect[i]];
        
        
        [self addSubview: pv[i]];
    }
    

    
    
    
    
    
    
    return self;
}


@end

//
//  drawProcessViewForSongControl.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/28/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "drawProcessViewForSongControl.h"

@implementation drawProcessViewForSongControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, 20.0);
    [[UIColor whiteColor] set];
    
    CGContextAddArc(context, 170, 170, 150, 0, 2*M_PI, NO); // 360 degree (0 to 2pi) arc
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, 20.0);
    [[UIColor colorWithRed:91.0/255.0 green:202.0/255.0 blue:92.0/255.0 alpha:1] set];
    
    CGContextAddArc(context, 170, 170, 150, 0, 2*M_PI*self.musicProgress, NO); // 360 degree (0 to 2pi) arc
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    
}

@end

//
//  DrawViewForVolume.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/18/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "DrawViewForVolume.h"

@implementation DrawViewForVolume

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
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
    [[UIColor colorWithRed:91.0/255.0 green:202.0/255.0 blue:92.0/255.0 alpha:0.3] set];
    CGContextAddArc(context, 175, 165, 106, 0, 2*M_PI, NO);
    CGContextStrokePath(context);
    UIGraphicsPopContext();

    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 20.0);
    [[UIColor colorWithRed:60/255.0 green:52/255.0 blue:52/255.0 alpha:1]set];
    CGContextAddArc(context, 175, 165, 106, 0, 2*M_PI*self.para,NO); // 360 degree (0 to 2pi) arc
    CGContextStrokePath(context);
    UIGraphicsPopContext();

}


@end

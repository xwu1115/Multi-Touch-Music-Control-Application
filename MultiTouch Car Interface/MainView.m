//
//  MainView.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/4/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "MainView.h"

@implementation MainView
@synthesize center = _center, radius = _radius;

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

-(void)setCenter:(CGPoint)center
{
    _center = center;
    [self setNeedsDisplay];
}
-(void)setRadius:(CGFloat)radius{
    _radius = radius;
    NSLog(@"the radius is %f",_radius);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawCircleAtPoint:_center withRadius:_radius inContext:context];
    
    //add animations to fade in/out the circle
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    for (int i=0; i<7; i++) {
        

       [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.6-0.1*i] set];
        
        CGContextAddArc(context, 175, 195,radius-30*i, 0, 2*M_PI, YES);
        CGContextStrokePath(context);

    }
   
    UIGraphicsPopContext();
}

- (void)drawDotAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    [[UIColor blueColor] set];
    
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES); // 360 degree (0 to 2pi) arc
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (AVAudioPlayer *)loadWav:(NSString *)filename {
    NSURL * url = [[NSBundle mainBundle] URLForResource:filename withExtension:@"mp3"];
    NSError * error;
    AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (!player) {
        NSLog(@"Error loading %@: %@", url, error.localizedDescription);
    } else {
        [player prepareToPlay];
    }
    return player;
}



@end

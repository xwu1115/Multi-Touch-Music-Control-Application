//
//  RatingControlView.m
//  MultiTouch
//
//  Created by Shawn Wu on 2/19/15.
//  Copyright (c) 2015 Shawn Wu. All rights reserved.
//

#import "RatingControlView.h"

@implementation RatingControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGestureRecognized:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGestureRecognized:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipeUp];
        [self addGestureRecognizer:swipeDown];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
}

-(void)handleSwipeGestureRecognized:(UISwipeGestureRecognizer *)rec{
    [self.delegate updateRating];
}
@end

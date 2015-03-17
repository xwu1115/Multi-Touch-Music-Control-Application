//
//  RatingControlView.m
//  MultiTouch
//
//  Created by Shawn Wu on 3/17/15.
//  Copyright (c) 2015 Shawn Wu. All rights reserved.
//

#import "RatingControlView.h"

#define LABEL_WIDTH 100
#define LABEL_HEIGHT 100

@implementation RatingControlView
@synthesize ratingImageArray,currentRating = _currentRating, RatingViewPath,ratingLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ratingLabel = [[UILabel alloc]initWithFrame:CGRectMake(80+125-LABEL_WIDTH/2, self.frame.size.height/2-LABEL_HEIGHT/2, LABEL_WIDTH, LABEL_HEIGHT)];
        [ratingLabel setTextColor:[UIColor whiteColor]];
        ratingLabel.textAlignment = UITextAlignmentCenter;
        ratingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:100.];
        ratingLabel.text = @"0";
        [self addSubview:ratingLabel];
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(450, 140, 500, 60)];
        contentLabel.text = @"Current Rating";
        contentLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50.0f];
        contentLabel.textColor = [UIColor whiteColor];
        [self addSubview:contentLabel];
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGestureRecognized:)];
        [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
        [self addGestureRecognizer:swipeDown];
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGestureRecognized:)];
        [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
        [self addGestureRecognizer:swipeUp];
        [self updateViewAccordingToRating];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self updateViewAccordingToRating];
}

-(void)setCurrentRating:(int)currentRating{
    if (currentRating < 5 && currentRating >= 0) {
        _currentRating = currentRating;
        [self setNeedsDisplay];
    }
}

-(void)handleSwipeGestureRecognized:(UISwipeGestureRecognizer *)recognizer
{
    [self.delegate changeRatingWith:recognizer AndView:self];
}

-(void)updateViewAccordingToRating{
    [UIView animateWithDuration:0.2 animations:^{
        ratingLabel.alpha = 0;
        for (int i = 0; i < 5; i++) {
            if(i <= _currentRating){
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
            }else{
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor darkGrayColor].CGColor);
            }
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(i*80 + 450, self.frame.size.height/2-25, 50, 50) cornerRadius:25];
            [path fill];
        }
    } completion:^(BOOL finished) {
        ratingLabel.text = [NSString stringWithFormat:@"%d",_currentRating+1];
        [UIView animateWithDuration:0.2 animations:^{
            ratingLabel.alpha = 1;
        }];
    }];
    RatingViewPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(80, self.frame.size.height/2-125, 250, 250) cornerRadius:125];
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor colorWithRed:204/255.0 green:51/255.0 blue:51/255.0 alpha:1].CGColor);
    [RatingViewPath fill];
}

@end


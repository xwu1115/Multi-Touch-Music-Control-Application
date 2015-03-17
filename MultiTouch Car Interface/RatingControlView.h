//
//  RatingControlView.h
//  MultiTouch
//
//  Created by Shawn Wu on 3/17/15.
//  Copyright (c) 2015 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
@class RatingControlView;
@protocol RatingDelegate
-(void)changeRatingWith:(UISwipeGestureRecognizer *)rec AndView:(RatingControlView *)v;
@end
@interface RatingControlView :MainView
@property int currentRating;
@property NSMutableArray *ratingImageArray;
@property UIBezierPath *RatingViewPath;
@property UILabel *ratingLabel;
@property id<RatingDelegate>delegate;
-(void)updateViewAccordingToRating;
@end

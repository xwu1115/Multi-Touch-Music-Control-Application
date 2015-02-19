//
//  RatingControlView.h
//  MultiTouch
//
//  Created by Shawn Wu on 2/19/15.
//  Copyright (c) 2015 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
@class RatingControlView;
@protocol RatingControlViewDelegate

-(void)updateRating;

@end
@interface RatingControlView : MainView
@property id<RatingControlViewDelegate> delegate;
@end

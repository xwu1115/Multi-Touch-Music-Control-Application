//
//  MainView.h
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/4/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCircleGestureRecognizer.h"
#import "AVFoundation/AVAudioPlayer.h"
@class MainView;
@protocol MainViewDataSource

-(CGFloat) getCircleRadius;
-(CGPoint) getCircleCenter;

@end

@interface MainView : UIView

@property id<MainViewDataSource>dataSource;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGPoint center;
@property NSString *songFileURL;
@end



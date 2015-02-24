//
//  MainViewController.h
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/2/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVAudioPlayer.h"
#import "MDCircleGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>
#import "TabBarView.h"
#import "SongControlView.h"
@interface MusicViewController : UIViewController<MDCircleGestureFailureDelegate, SongControlViewDelegate,UIGestureRecognizerDelegate, TabBarViewDelegate>

@end

//
//  VolumeControlView.h
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/6/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "DrawViewForVolume.h"
@class VolumeControlView;

@interface VolumeControlView :MainView
@property UILabel *parameter;
@property DrawViewForVolume *drawView;
@property NSString* songFileURL;
@property(nonatomic) UIView* musicView;
@property NSString *paraString;
@property UILabel *songName;
@property UILabel *author;
@end

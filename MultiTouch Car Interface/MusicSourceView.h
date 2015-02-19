//
//  MusicSourceView.h
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/6/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "SongControlView.h"
@interface MusicSourceView :MainView

@property UILabel *statusOff;
@property UILabel *statusOn;
-(void)setupStatus:(BOOL)status;
@end

//
//  SongControlView.h
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/6/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "drawProcessViewForSongControl.h"
#import <MediaPlayer/MediaPlayer.h>

@class SongControlView;
@protocol SongControlViewDelegate

-(void)turnToRadioView;
-(void)backToSongView;

@end

@interface SongControlView :MainView
@property NSMutableArray *albumImages;
@property float musicProgress;
@property Boolean isRadio;
@property Boolean isInradioView;
@property id<SongControlViewDelegate>delegate;
@property UIView *containerView;
@property drawProcessViewForSongControl *drawView;
@property UIView *rightSpace;
@property UILabel *songName;
@property UILabel *author;
@property NSMutableArray *songNameArray;
@property NSMutableArray *authorArray;

-(UIView *)addAlbumViewWith:(UIImage *)image WithContent:(NSString *)content;

@end

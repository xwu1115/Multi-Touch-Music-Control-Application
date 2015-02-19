//
//  ItunesLibraryController.h
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 4/10/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ItunesLibraryController : NSObject

@property MPMusicPlayerController *myPlayer;

-(void)setupItunesFetchWithTitleAray:(NSArray *)itunesTitleArray;
-(void)playItunesSong;

@end

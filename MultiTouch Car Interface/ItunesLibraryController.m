//
//  ItunesLibraryController.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 4/10/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "ItunesLibraryController.h"

@implementation ItunesLibraryController
@synthesize  myPlayer = _myPlayer;

+(void)initialize{
    [super initialize];

}

-(void)setupItunesFetchWithTitleAray:(NSArray *)itunesTitleArray
{
    _myPlayer = [MPMusicPlayerController applicationMusicPlayer];
    
    MPMediaPropertyPredicate *playlistPredicate = [MPMediaPropertyPredicate predicateWithValue: itunesTitleArray forProperty:MPMediaItemPropertyTitle];
    NSSet *predicateSet = [NSSet setWithObjects:playlistPredicate, nil];
    MPMediaQuery *mediaTypeQuery = [[MPMediaQuery alloc] initWithFilterPredicates:predicateSet];
    
//    MPMediaQuery *mediaTypeQuery = [[MPMediaQuery alloc]init];
    [_myPlayer setQueueWithQuery:mediaTypeQuery];
    
}

-(void)playItunesSong
{
    [_myPlayer play];
}


@end

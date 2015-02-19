//
//  SongControlView.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/6/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "SongControlView.h"
#import "RadioControlView.h"

@implementation SongControlView
@synthesize musicProgress=_musicProgress, isRadio = _isRadio;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.songFileURL = @"Music Control";
        self.isRadio = false;
        self.isInradioView = false;
            
        self.albumImages = [NSMutableArray array];
        self.songNameArray = [NSMutableArray array];
        self.authorArray = [NSMutableArray array];
        
        [self setupDrawViewAndContainerView];
        
        [self setUpArtWorkAndMusic];
            
        int i=0;
        for (id image in self.containerView.subviews)
        {
            CGRect currentFrame = ((UIView *)image).frame;
            currentFrame.origin.y=225*i;
            ((UIView *)image).frame = currentFrame;
            ((UIView *)image).backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            i++; 
        }
        
        [self setupRightSpaceDetail];
        

    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setupRightSpaceDetail{
    
    self.rightSpace = [[UIView alloc]initWithFrame:CGRectMake(420, 0, 522, 500)];
    self.rightSpace.backgroundColor = [UIColor whiteColor];
    
    self.songName = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 400, 150)];
    [self.songName setTextColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1]];
    self.songName.font =[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60.0f];
    self.songName.text = [self.songNameArray objectAtIndex:0];
    self.songName.textAlignment=UITextAlignmentLeft;
    self.songName.numberOfLines = 2;
    //[self.songName sizeToFit];
    self.songName.adjustsFontSizeToFitWidth = YES;
    [self.rightSpace addSubview:self.songName];
    
    self.author = [[UILabel alloc] initWithFrame:CGRectMake(50, 250, 400, 100)];
    [self.author setTextColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1]];
    self.author.font =[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40.0f];
    self.author.text = [self.authorArray objectAtIndex:0];
    self.author.textAlignment=UITextAlignmentLeft;
    self.author.numberOfLines = 1;
    //[self.author sizeToFit];
    [self.rightSpace addSubview:self.author];
    
    [self addSubview:self.rightSpace];
    
}

- (void)drawRect:(CGRect)rect
{
   
}

-(void)setupDrawViewAndContainerView{
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(50, 100, 310, 310)];
    self.containerView.layer.cornerRadius = 155;
    self.containerView.clipsToBounds = YES;
    
    self.drawView = [[drawProcessViewForSongControl alloc]initWithFrame:CGRectMake(35, 85, 350, 350)];
    self.drawView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    [self addSubview:self.containerView];
    [self addSubview:self.drawView];
}

-(void)createImageViewWith:(UIImage *)image
{
    if (image) {
        [self.albumImages addObject:image];
    }
    else{
        image = [UIImage imageNamed:@"Paradise.jpg"];//place to add no artwork image......
        [self.albumImages addObject:image];
           }
    UIView *currentView = [self addAlbumViewWith:image];
    [ self.containerView addSubview:currentView];

}

-(UIView *)addAlbumViewWith:(UIImage *)image
{
    UIView *albumView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 600, 250)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 300, 300);
    imageView.layer.cornerRadius =150;
    imageView.clipsToBounds = YES;
    [albumView addSubview:imageView];
    return  albumView;
    
}

-(void)setMusicProgress:(float)musicProgress{
    _musicProgress = musicProgress;
    self.drawView.musicProgress = musicProgress;
    [self.drawView setNeedsDisplay];
}

-(void)setIsRadio:(Boolean)isRadio
{
    _isRadio = isRadio;
    if (_isRadio) {
        
        [self.delegate turnToRadioView];
        self.isInradioView = true;
        
    }
    else if(!_isRadio && self.isInradioView) {
        [self.delegate backToSongView];

    }
}

-(void)setUpArtWorkAndMusic{
    
    MPMediaQuery *mediaTypeQuery = [MPMediaQuery songsQuery];
    
    NSArray *allAlbumsArray = [mediaTypeQuery collections];
    
    for (MPMediaItemCollection *collection in allAlbumsArray) {
        
        MPMediaItem *item = [collection representativeItem];
       
        MPMediaItemArtwork *itemArtwork = [item valueForProperty:MPMediaItemPropertyArtwork];
        
        UIImage *artworkUIImage = [itemArtwork imageWithSize:CGSizeMake(640, 640)];
        
        NSString *artist = [item valueForProperty:MPMediaItemPropertyArtist];
        
        NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
       
        [self createImageViewWith:artworkUIImage];
        
        [self.songNameArray addObject:title];
        
        [self.authorArray addObject:artist];

    }
    
}

@end

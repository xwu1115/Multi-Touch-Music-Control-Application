//
//  RadioControlView.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/16/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "RadioControlView.h"

@implementation RadioControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self createImageForArray];
        
        int i=0;
        
        for (id image in self.subviews) {
            
            CGRect currentFrame = ((UIView *)image).frame;
            currentFrame.origin.y=-125+250*i;
            ((UIView *)image).frame = currentFrame;
            ((UIView *)image).backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            i++;
        }
        
        self.radioStreamingUrl = [[NSMutableString alloc]initWithFormat: @"http://shoutmedia.abc.net.au:10320"];
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

- (void)drawRect:(CGRect)rect
{
    
}

 -(UIView *)addAlbumViewWith:(UIImage *)image WithContent:(NSString *)content
{
        UIView *albumView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 600, 250)];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(350, 100, 500, 50)];
        contentLabel.text = content;
        contentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:50.0f];
        contentLabel.textColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(75, 25, 200, 200);
        imageView.layer.cornerRadius =100;
        imageView.clipsToBounds = YES;
        [albumView addSubview:imageView];
        [albumView addSubview:contentLabel];
        
        return  albumView;
        
}

-(void)createImageForArray
{
    UIImage *firstImage = [UIImage imageNamed:@"abc.png"];
    UIImage *secondImage = [UIImage imageNamed:@"abc.png"];
    UIImage *thirdImage = [UIImage imageNamed:@"abc.png"];
    
    self.albumImages = [NSMutableArray array];
    [self.albumImages addObject:firstImage];
    [self.albumImages addObject:secondImage];
    [self.albumImages addObject:thirdImage];
    
    UIView *firstSong = [self addAlbumViewWith:firstImage WithContent:self.radioStreamingUrl];
    UIView *secondSong = [self addAlbumViewWith:secondImage WithContent:@""];
    UIView *thirdSong = [self addAlbumViewWith:thirdImage WithContent:@""];
    
    [self addSubview:firstSong];
    [self addSubview:secondSong];
    [self addSubview:thirdSong];
}

    
-(void)changeStreamNumber{
    NSString *currentIndex = [self.radioStreamingUrl substringToIndex:(self.radioStreamingUrl.length -2)];
    self.radioStreamingUrl = [self.radioStreamingUrl substringToIndex:(self.radioStreamingUrl.length -3)];
    int i = [currentIndex intValue];
    i++;
    currentIndex = [NSString stringWithFormat:@"%d",i];
    self.radioStreamingUrl = [self.radioStreamingUrl stringByAppendingString:currentIndex];
}
@end

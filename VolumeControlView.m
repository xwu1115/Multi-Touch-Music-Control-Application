//
//  VolumeControlView.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/6/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "VolumeControlView.h"
#import <QuartzCore/QuartzCore.h>

@implementation VolumeControlView
@synthesize musicView = _musicView,parameter = _parameter, drawView =_drawView,paraString =_paraString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 940, 500)];
        grayView.backgroundColor = [UIColor colorWithRed:56/255.0 green:53/255.0 blue:53/255.0 alpha:0.5];
        [self addSubview:grayView];
        
        self.parameter = [[UILabel alloc]init];
        self.parameter.frame = CGRectMake(300, 50, 520, 100);
        [self.parameter setTextColor:[UIColor whiteColor]];
        self.parameter.font =[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:80.0f];
        self.parameter.text = @"100.0 dB";
        self.parameter.textAlignment=UITextAlignmentRight;
        
        self.parameter.shadowColor = ([UIColor blackColor]);
        self.parameter.shadowOffset = CGSizeMake(1.5, 1);
        self.parameter.clipsToBounds = NO;
        
        [self addSubview:self.parameter];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.bounds.size.width, 300)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        
        UIImage *volumeIcon = [UIImage imageNamed:@"volume_rev_2.png"];//volume_Icon.png
        UIImageView *volumeIconView = [[UIImageView alloc]initWithImage:volumeIcon];
        volumeIconView.frame = CGRectMake(75, 65, 200, 200);
        [self addSubview:volumeIconView];
        
        if (self.musicView) {
            [self addSubview:self.musicView];
        }
        
        _drawView =[[DrawViewForVolume alloc]initWithFrame:CGRectMake(0, 0, 940, 300)];
        [self addSubview:_drawView];
        
        self.songName = [[UILabel alloc] initWithFrame:CGRectMake(300, 220, 520, 100)];
        [self.songName setTextColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1]];
        self.songName.font =[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60.0f];
        self.songName.text = @"Song Name";
        self.songName.textAlignment=UITextAlignmentRight;
        [self addSubview:self.songName];

        self.author = [[UILabel alloc] initWithFrame:CGRectMake(300, 300, 520, 100)];
        [self.author setTextColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1]];
        self.author.font =[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:45.0f];
        self.author.text = @"Author";
        self.author.textAlignment=UITextAlignmentRight;
        [self addSubview:self.author];
        
        self.songFileURL = @"volume";
        
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

-(void)setMusicView:(UIView *)musicView
{
    if (self.musicView) {
        [self.musicView removeFromSuperview];
    }
    
    _musicView = musicView;
    [self addSubview:_musicView];
    [self sendSubviewToBack:_musicView];
    
}

-(void)setParaString:(NSString *)paraString{
    
    _parameter.text = paraString;
    self.drawView.para = ([_parameter.text floatValue]/200.0);
    [self.drawView setNeedsDisplay];

}

@end

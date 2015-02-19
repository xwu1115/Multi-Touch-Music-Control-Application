//
//  MusicSourceView.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/6/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "MusicSourceView.h"

@implementation MusicSourceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImage *radioWave = [UIImage imageNamed:@"radioWave.png"];
        UIImageView *radioWaveView = [[UIImageView alloc]initWithImage:radioWave];
        
        
        
        CGRect currentFrame = CGRectMake((420 - radioWaveView.frame.size.width/2)/2, 160, radioWaveView.frame.size.width/2, radioWaveView.frame.size.height/2);
        radioWaveView.frame = currentFrame;
        
        [self addSubview:radioWaveView];
        
        [self setUpRightSpace];
         self.songFileURL = @"source";
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

-(void)setUpRightSpace
{
    UIView *rightSpace = [[UIView alloc]initWithFrame:CGRectMake(420, 0, 522, 500)];
    rightSpace.backgroundColor = [UIColor whiteColor];
    
    UILabel *radioName = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 400, 150)];
    [radioName setTextColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1]];
    radioName.font =[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60.0f];
    radioName.text = @"Radio Streaming";
    radioName.textAlignment=UITextAlignmentLeft;
    radioName.numberOfLines = 2;
    //[self.songName sizeToFit];
    radioName.adjustsFontSizeToFitWidth = YES;
    [rightSpace addSubview:radioName];
    
    self.statusOff = [[UILabel alloc] initWithFrame:CGRectMake(50, 270, 400, 150)];
    [self.statusOff setTextColor:[UIColor colorWithRed:91.0/255.0 green:202.0/255.0 blue:92.0/255.0 alpha:1]];
    self.statusOff.font =[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:85.0f];
    self.statusOff.text = @"OFF";
    [rightSpace addSubview:self.statusOff];
    
    self.statusOn = [[UILabel alloc] initWithFrame:CGRectMake(50, 400, 400, 150)];
    [self.statusOn setTextColor:[UIColor colorWithRed:91.0/255.0 green:202.0/255.0 blue:92.0/255.0 alpha:1]];
    self.statusOn.font =[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:85.0f];
    self.statusOn.text = @"ON";
    self.statusOn.alpha = 0;
    [rightSpace addSubview:self.statusOn];
    
    [self addSubview:rightSpace];
    
}

-(void)setupStatus:(BOOL)status{
    if (status == YES)
    {
        [UIView animateKeyframesWithDuration:0.3f
                                       delay:0
                                     options:UIViewAnimationCurveEaseInOut
                                  animations:^{
                                      self.statusOff.frame = CGRectMake(self.statusOff.frame.origin.x, self.statusOff.frame.origin.x+100, self.statusOff.frame.size.width, self.statusOff.frame.size.height);
                                      self.statusOff.alpha = 0;
                                      
                                      self.statusOn.frame = CGRectMake(self.statusOn.frame.origin.x, 270, self.statusOn.frame.size.width, self.statusOn.frame.size.height);
                                      self.statusOn.alpha = 1;
                                      
                                      
                                  }
                                  completion:nil];
    }
    else
    {
        [UIView animateKeyframesWithDuration:0.3f
                                       delay:0
                                     options:UIViewAnimationCurveEaseInOut
                                  animations:^{
                                      self.statusOff.frame = CGRectMake(self.statusOff.frame.origin.x, 270, self.statusOff.frame.size.width, self.statusOff.frame.size.height);
                                      self.statusOff.alpha = 1;
                                      
                                      self.statusOn.frame = CGRectMake(self.statusOn.frame.origin.x, 400, self.statusOn.frame.size.width, self.statusOn.frame.size.height);
                                      self.statusOn.alpha = 0;
                                      
                                      
                                  }
                                  completion:nil];
 
        
    }
}

@end

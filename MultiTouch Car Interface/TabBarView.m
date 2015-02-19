//
//  TabBarView.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/14/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "TabBarView.h"

@implementation TabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
            }
    return self;
}

-(void)addImagesToViewWith:(NSArray *)imageArray{
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
//    NSMutableString *music = [[NSMutableString alloc]initWithFormat:@"music-icon1" ];
//    NSMutableString *climate =[[NSMutableString alloc]initWithFormat:@"climate-icon" ];
//    NSMutableString *navi = [[NSMutableString alloc]initWithFormat:@"navi-icon" ];
//    
//    switch([self.delegate updateTheTabBarView]) {
//            
//        case 0: [music appendString:@"_on"];
//            break;
//        case 1:;
//        case 2:[navi appendString:@"_on"];
//            break;
//            
//    }
//    [music appendString:@".png"];
//    [climate appendString:@".png"];
//    [navi appendString:@".png"];
//    
//    UIImage *musicIcon = [UIImage imageNamed:music];
//    UIImageView *musicIconView = [[UIImageView alloc]initWithImage:musicIcon];
//    musicIconView.frame = CGRectMake(5, 0, 330, self.frame.size.height*0.7);
//    musicIconView.contentMode = UIViewContentModeScaleAspectFit;
//    
//    UIImage *climateIcon = [UIImage imageNamed:climate];
//    UIImageView *climateIconView = [[UIImageView alloc]initWithImage:climateIcon];
//    climateIconView.frame = CGRectMake(musicIconView.frame.size.width+5, 0, 330, self.frame.size.height*0.7);
//    climateIconView.contentMode = UIViewContentModeScaleAspectFit;
//    
//    UIImage *naviIcon = [UIImage imageNamed:navi];
//    UIImageView *naviIconView = [[UIImageView alloc]initWithImage:naviIcon];
//    naviIconView.frame = CGRectMake(musicIconView.frame.size.width+climateIconView.frame.size.width+5, 0, 330, self.frame.size.height*0.7);
//    naviIconView.contentMode = UIViewContentModeScaleAspectFit;
//    
//    [self addSubview:musicIconView];
//    [self addSubview:climateIconView];
//    [self addSubview:naviIconView];
    
    for (int i=0;i<[imageArray count];i++) {
        UIImageView *currentImage = [[UIImageView alloc]initWithImage:[imageArray objectAtIndex:i]];
        CGRect currentFrame = currentImage.frame;
        currentFrame.origin.y = (self.frame.size.height - currentFrame.size.height)/2;
        currentFrame.origin.x = 100+100*i;
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end

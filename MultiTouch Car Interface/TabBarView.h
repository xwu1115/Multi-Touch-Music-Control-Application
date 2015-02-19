//
//  TabBarView.h
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/14/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBarView;
@protocol TabBarViewDelegate
-(int)updateTheTabBarView;
@end

@interface TabBarView : UIView
@property id<TabBarViewDelegate>delegate;
-(void)addImagesToViewWith:(NSArray *)imageArray;
@end

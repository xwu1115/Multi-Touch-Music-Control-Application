//
//  RadioControlView.h
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/16/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongControlView.h"
@interface RadioControlView : MainView
@property NSMutableString *radioStreamingUrl;

@property NSMutableArray *albumImages;
@property float musicProgress;
@property Boolean isRadio;
@property Boolean isInradioView;
-(UIView *)addAlbumViewWith:(UIImage *)image WithContent:(NSString *)content;
@end

//
//  MainViewController.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/2/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "MusicViewController.h"
#import "VolumeControlView.h"
#import "SongControlView.h"
#import "MusicSourceView.h"
#import "RadioControlView.h"
#import "MainView.h"
#import "NaviViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "AudioStreamer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RatingControlView.h"

@interface MusicViewController ()

#define FRAME_WIDTH ((int)1024);
#define FRAME_HEIGHT 768;

@property int musicIndex;
@property int viewMoveDirection;
@property BOOL whetherIsSwipe;
@property int notifyTimes;
@property SongControlView *songControlView;
@property VolumeControlView *volumeControlView;
@property MusicSourceView *musicSourceView;
@property RadioControlView *radioControlView;
@property RatingControlView *ratingControlView;
@property TabBarView *tabBarView;

@property NSMutableArray *views;
@property NSMutableArray *tempViews;
@property AVAudioPlayer *indicator;
@property int currentViewIndex;

@property CGPoint circleCenter;
@property CGFloat circleRadius;

@property AVAudioPlayer *player;
@property float currentVolume;
@property MPMusicPlayerController *musicPlayer;
@property  UIProgressView *progressView;
@property AudioStreamer *streamer;
@property int musicSoure;

@property NSMutableArray *subItemIconArray;
@property (weak, nonatomic) IBOutlet UIView *volumeIcon;
@property (weak, nonatomic) IBOutlet UIView *songIcon;
@property (weak, nonatomic) IBOutlet UIView *radioIcon;
@property (weak, nonatomic) IBOutlet UIImageView *musicMenuIcon;

@end

@implementation MusicViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
}

- (void)updateProgressBar:(float)progress
{
    if (progress >= 0 && progress <= 1)  {
        self.progressView.progress = progress;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:60/255.0 green:52/255.0 blue:52/255.0 alpha:1];

    //create view for drawing
    self.volumeControlView = [[VolumeControlView alloc]initWithFrame:CGRectMake(0, 0, 940, 500)];
    self.volumeControlView.backgroundColor = [UIColor colorWithRed:56/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(100, 440, 740, 50)];
    //change the height of the progress bar..
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 15.0f);
    self.progressView.transform = transform;
    [self.progressView setTintColor:[UIColor colorWithRed:91.0/255.0 green:202.0/255.0 blue:92.0/255.0 alpha:1]];
    [self.volumeControlView addSubview:self.progressView];
    
    self.songControlView = [[SongControlView alloc]initWithFrame:CGRectMake(0, 0, 940, 500)];
    self.songControlView.backgroundColor = [UIColor colorWithRed:56/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    self.songControlView.delegate = self;
    
    self.musicSourceView = [[MusicSourceView alloc]initWithFrame:CGRectMake(0, 0, 940, 500)];
    self.musicSourceView.backgroundColor = [UIColor colorWithRed:56/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    
    self.ratingControlView = [[RatingControlView alloc]initWithFrame:CGRectMake(0, 0, 940, 500)];
    self.ratingControlView.backgroundColor = [UIColor colorWithRed:56/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    
    self.views = [NSMutableArray array];
    
    self.tempViews = [NSMutableArray array];
    
    [self.tempViews addObject:self.volumeControlView];
    [self.tempViews addObject:self.songControlView];
    [self.tempViews addObject:self.musicSourceView];
    [self.tempViews addObject:self.ratingControlView];

    //add shadow and round corner to the views
    [self setupViews];
    
    self.currentVolume = 10.0;
    
    self.currentViewIndex = 0;
    self.musicIndex = 0;
    
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    
    NSSet *predicateSet = [NSSet setWithObjects:nil];
    MPMediaQuery *mediaTypeQuery = [MPMediaQuery songsQuery];
    [self.musicPlayer setQueueWithQuery:mediaTypeQuery];
   // NSLog(@"the query results are %@", mediaTypeQuery);
    self.musicPlayer.repeatMode = MPMusicRepeatModeAll;
    [self.musicPlayer play];
    
    [self.volumeControlView.author setText:[self.songControlView.authorArray objectAtIndex:self.musicIndex]];
    [self.volumeControlView.songName setText: [self.songControlView.songNameArray objectAtIndex:self.musicIndex]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector:    @selector (handle_NowPlayingItemChanged:)
     name:        MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object:     self.musicPlayer];
    
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    
   	// Do any additional setup after loading the view.
    
    [self setupGestures];

    self.indicator = [self loadWav:((MainView *)[self.tempViews objectAtIndex:self.currentViewIndex]).songFileURL] ;
    [self.indicator play];
    
    for (id view in self.tempViews) {
        if ([view isKindOfClass:[SongControlView class]]) {
            [self setMusicForVolumeView: [((SongControlView *)view).albumImages objectAtIndex:self.musicIndex] withContent:@""];
        }
    }
    
    self.whetherIsSwipe = NO;
    self.notifyTimes = 0;
    
    self.subItemIconArray = [NSMutableArray array];
    [self.subItemIconArray addObject:self.volumeIcon];
    [self.subItemIconArray addObject:self.songIcon];
    [self.subItemIconArray addObject:self.radioIcon];
}

-(void)viewDidAppear:(BOOL)animated
{

    CAKeyframeAnimation * anim1 = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim1.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2f, 0.2f, 1.0f)], [ NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f) ]];
    anim1.autoreverses = NO;
    anim1.repeatCount = 0;
    anim1.duration = .4f;
    
    [self.musicMenuIcon.layer addAnimation:anim1 forKey:nil];
    [self checkViewIndex];
}

-(void)viewWillAppear:(BOOL)animated
{
   
    
}

-(void)setupGestures{
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    
//    MDCircleGestureRecognizer *circleGesture = [[MDCircleGestureRecognizer alloc]init];
//    [circleGesture addTarget:self action:@selector(handleCircle:)];
    
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeGestureUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeGestureDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    //[self.view addGestureRecognizer:circleGesture];
    
    [self.view addGestureRecognizer:swipeGestureLeft];
    [self.view addGestureRecognizer:swipeGestureRight];
    [self.view addGestureRecognizer:swipeGestureUp];
    [self.view addGestureRecognizer:swipeGestureDown];
    [self.view addGestureRecognizer:pinchGesture];
    
    //circleGesture.delegate = self;
    pinchGesture.delegate = self;
    
}

-(void)setupViews{
    
    int currentIndex = 0;
    for (id view in self.tempViews) {
        
        /* still neew round corner*/
        ((UIView *)view).layer.shouldRasterize = YES;
        ((UIView *)view).layer.cornerRadius = 6;
        ((UIView *)view).layer.masksToBounds = YES;
        CGRect currentFrame = ((UIView *)view).frame;
        currentFrame.origin.x= 42+currentIndex*960;
        currentFrame.origin.y= 40;
        
        UIView *containerView = [[UIView alloc]initWithFrame:currentFrame];
        [containerView addSubview:((UIView *)view)];
        
        containerView.layer.shadowOffset = CGSizeMake(0, 5);
        containerView.layer.shadowRadius = 5;
        containerView.layer.shadowOpacity = 0.7;
        containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:containerView.layer.bounds cornerRadius:4].CGPath;
        
        [self.views addObject:containerView];
        [self.view addSubview:containerView];
        currentIndex++;
    }
}

- (void)updateTime:(NSTimer *)timer{
    
    [self.progressView setProgress:(self.musicPlayer.currentPlaybackTime/[[self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue])];
    self.songControlView.musicProgress = (self.musicPlayer.currentPlaybackTime/[[self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue]);
    
    //set the roundprogress bar on the songControlView..
}

-(void)setMusicForVolumeView:(UIImage *)ablumImage withContent:(NSString *)content
{
    for (id view in self.tempViews) {
        
        if ([view isKindOfClass:[VolumeControlView class]]) {
            
            VolumeControlView *currentView = view;
            
            UIImageView * ablumView = [[UIImageView alloc]initWithImage:ablumImage];
            ablumView.frame = CGRectMake(0, 0, 940, 500);
            
            ablumView.contentMode = UIViewContentModeScaleAspectFill;
            currentView.musicView = ablumView;
        };
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Gesture Handling
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction==UISwipeGestureRecognizerDirectionLeft||gesture.direction==UISwipeGestureRecognizerDirectionRight) {
            if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
                if (self.currentViewIndex < [self.views count]-1)
                {
                    CGRect currentFrame = CGRectMake(42 - 1*960, 40, ((UIView *)[self.views objectAtIndex:self.currentViewIndex]).frame.size.width, ((UIView *)[self.views objectAtIndex:self.currentViewIndex]).frame.size.height);
                    
                    CGRect nextFrame = CGRectMake(42, 40, ((UIView *)[self.views objectAtIndex:self.currentViewIndex]).frame.size.width, ((UIView *)[self.views objectAtIndex:self.currentViewIndex]).frame.size.height);
                    
                    [UIView animateWithDuration:0.5
                                          delay:0
                                        options: UIViewAnimationCurveEaseInOut
                                     animations:^{
                                         self.currentViewIndex ++;
                                         [self checkViewIndex];
                                         ((UIView *)[self.views objectAtIndex:self.currentViewIndex-1]).frame = currentFrame;
                                         ((UIView *)[self.views objectAtIndex:(self.currentViewIndex)]).frame = nextFrame;
                                         
                                     }
                                     completion:^(BOOL finished){
                                         self.indicator = [self loadWav:((MainView *)[((UIView *)[self.views objectAtIndex:(self.currentViewIndex)]).subviews lastObject]).songFileURL] ;
                                         [self.indicator play];
                                     }];
                }
                else{
                    CATransition* transition = [CATransition animation];
                    transition.duration = 0.6;
                    transition.type = kCATransitionFade;
                    //transition.subtype = kCATransitionFromRight;
                    [self.view.window.layer addAnimation:transition forKey:kCATransition];
                    
                    [self.tabBarController setSelectedIndex:2];
                }
            }
            
            if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
                if (self.currentViewIndex > 0)
                {
                    CGRect currentFrame = CGRectMake(42 + 1*960, 40, ((UIView *)[self.views objectAtIndex:self.currentViewIndex]).frame.size.width, ((UIView *)[self.views objectAtIndex:self.currentViewIndex]).frame.size.height);
                    CGRect nextFrame = CGRectMake(42, 40, ((UIView *)[self.views objectAtIndex:self.currentViewIndex]).frame.size.width, ((UIView *)[self.views objectAtIndex:self.currentViewIndex]).frame.size.height);
                    [UIView animateWithDuration:0.5
                                          delay:0
                                        options: UIViewAnimationCurveEaseInOut
                                     animations:^{
                                         self.currentViewIndex --;
                                         [self checkViewIndex];
                                         ((UIView *)[self.views objectAtIndex:self.currentViewIndex+1]).frame = currentFrame;
                                         ((UIView *)[self.views objectAtIndex:(self.currentViewIndex)]).frame = nextFrame;
                                     }
                                     completion:^(BOOL finished){
                                         self.indicator = [self loadWav:((MainView *)[((UIView *)[self.views objectAtIndex:(self.currentViewIndex)]).subviews lastObject]).songFileURL] ;
                                         [self.indicator play];
                                     }];
                }
                else{
                }
        }
    }
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp||gesture.direction == UISwipeGestureRecognizerDirectionDown)
    {
       //if it's in the songControl view..
        self.whetherIsSwipe = YES;
        
        if ([[self.tempViews objectAtIndex:self.currentViewIndex] isKindOfClass:[SongControlView class]])
        {
           //[self.musicPlayer stop];
            SongControlView *currentSongControlView = [self.tempViews objectAtIndex:self.currentViewIndex];
            int previousIndex = self.musicIndex;
             CGRect nextFrame = ((UIImageView *)[currentSongControlView.containerView.subviews objectAtIndex:self.musicIndex]).frame;
             self.viewMoveDirection = 0;
             if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
                if (self.musicIndex < [currentSongControlView.albumImages count]-1) {
                    self.musicIndex++;
                    [self.musicPlayer skipToNextItem];
                    self.viewMoveDirection = -1;
                }
            }
            
            if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
                if (self.musicIndex >= 1) {
                    self.musicIndex--;
                    [self.musicPlayer skipToPreviousItem];
                    self.viewMoveDirection = 1;
                }
            }
            //[self.musicPlayer play];
            CGRect currentFrame = ((UIImageView *)[currentSongControlView.containerView.subviews objectAtIndex:self.musicIndex]).frame;
            currentFrame = CGRectMake(currentFrame.origin.x, 0, currentFrame.size.width, currentFrame.size.height);
            nextFrame = CGRectMake(nextFrame.origin.x, nextFrame.origin.y+self.viewMoveDirection*225, nextFrame.size.width, nextFrame.size.height);
            
            //draw a customized progress bar
            [UIView animateWithDuration:0.5
                                  delay:0
                                options: UIViewAnimationCurveEaseInOut
                             animations:^{
                                 ((UIView *)[currentSongControlView.containerView.subviews objectAtIndex:self.musicIndex]).frame = currentFrame ;
                                 ((UIView *)[currentSongControlView.containerView.subviews objectAtIndex:previousIndex]).frame = nextFrame;
                                 ((UIView *)[currentSongControlView.containerView.subviews objectAtIndex:previousIndex]).alpha = 0.2;
                                 ((UIView *)[currentSongControlView.containerView.subviews objectAtIndex:self.musicIndex]).alpha = 1;
                                 self.songControlView.songName.alpha = 0;
                                 self.songControlView.author.alpha = 0;
                             }
                             completion:^(BOOL finished){
                                 
                                 [self setMusicForVolumeView:[currentSongControlView.albumImages objectAtIndex:self.musicIndex] withContent:@""];
                                 [self.songControlView.songName setText: [self.songControlView.songNameArray objectAtIndex:self.musicIndex]];
                                 [self.songControlView.author setText:[self.songControlView.authorArray objectAtIndex:self.musicIndex]];
                                 
                                 [self.volumeControlView.author setText:[self.songControlView.authorArray objectAtIndex:self.musicIndex]];
                                 [self.volumeControlView.songName setText: [self.songControlView.songNameArray objectAtIndex:self.musicIndex]];
                                 
                                 [UIView animateWithDuration:0.2
                                                       delay:0
                                                     options: UIViewAnimationCurveEaseInOut
                                                  animations:^{
                                                      self.songControlView.songName.alpha = 1;
                                                      self.songControlView.author.alpha = 1;
                                                  }
                                                  completion:nil];
                                // NSLog(@"the index is %d", self.musicIndex);
                                 self.whetherIsSwipe = NO;
                             }];
        }
        //if it's in the musicSoureccontrol view..
        if ([[self.tempViews objectAtIndex:self.currentViewIndex]isKindOfClass:[MusicSourceView class]]) {
            self.songControlView.isRadio = 1-1*self.songControlView.isRadio;
            [self.musicSourceView setupStatus:self.songControlView.isRadio];
        }
    
        //if it's in the radioCcontrol view..
        if ([[self.tempViews objectAtIndex:self.currentViewIndex]isKindOfClass:[RadioControlView class]]) {
        }
    }
}

-(void)handleCircle:(MDCircleGestureRecognizer *)gesture
{
}

-(void)handlePinch:(UIGestureRecognizer *)gesture
{
   // NSLog(@"the current scale is %f",((UIPinchGestureRecognizer *)gesture).scale);
    //set the value on the screen
    if (((UIPinchGestureRecognizer *)gesture).scale != 0) {
        self.currentVolume  = ((UIPinchGestureRecognizer *)gesture).scale * 100 * self.musicPlayer.volume ;
        if (self.currentVolume<200) {
            NSString *currentValue = [[[ NSString stringWithFormat:@"%f",self.currentVolume] substringToIndex:5] stringByAppendingString:@" dB"];
            self.volumeControlView.paraString = currentValue;
            [self.musicPlayer setVolume:((UIPinchGestureRecognizer *)gesture).scale];
        }
        else{
            self.volumeControlView.parameter.text = @"200 dB";
        }
    }
    else{
        self.currentVolume=10.0;
    }
    self.volumeControlView.radius = ((UIPinchGestureRecognizer *)gesture).scale *100 *self.musicPlayer.volume;
}

#pragma mark delegate method

- (void) circleGestureFailed:(MDCircleGestureRecognizer *)gr{
}

-(void)turnToRadioView{
    
    self.radioControlView = [[RadioControlView alloc]initWithFrame:CGRectMake(0, 0, 940, 500)];
    self.radioControlView.backgroundColor = [UIColor colorWithRed:56/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    [self.tempViews replaceObjectAtIndex:1 withObject:self.radioControlView];
    
    //update the views array..
    [self setupNewView];
}

-(void)backToSongView{
    [self.tempViews replaceObjectAtIndex:1 withObject:self.songControlView];
    [self setupNewView];
}

-(void)setupNewView{
    for ( UIView *view in self.view.subviews ) {
        if ([[view.subviews lastObject]isKindOfClass:[SongControlView class]] || [[view.subviews lastObject]isKindOfClass:[RadioControlView class]]) {
            [view removeFromSuperview];
            ((UIView *)[self.tempViews objectAtIndex:1]).layer.shouldRasterize = YES;
            ((UIView *)[self.tempViews objectAtIndex:1]).layer.cornerRadius = 6;
            ((UIView *)[self.tempViews objectAtIndex:1]).layer.masksToBounds = YES;
            CGRect currentFrame =  ((UIView *)[self.tempViews objectAtIndex:1]).frame;
            currentFrame.origin.x= 42-1*960;
            currentFrame.origin.y= 40;
            UIView *containerView = [[UIView alloc]initWithFrame:currentFrame];
            [containerView addSubview: ((UIView *)[self.tempViews objectAtIndex:1])];
            
            containerView.layer.shadowOffset = CGSizeMake(0, 5);
            containerView.layer.shadowRadius = 5;
            containerView.layer.shadowOpacity = 0.7;
            containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:containerView.layer.bounds cornerRadius:4].CGPath;
            
            [self.views replaceObjectAtIndex:1 withObject:containerView];
            [self.view addSubview:containerView];
            
            if ([[containerView.subviews lastObject]isKindOfClass:[RadioControlView class]]) {
                [self.musicPlayer pause];
                [self createStreamerWith:self.radioControlView.radioStreamingUrl];
            }
            if ([[containerView.subviews lastObject]isKindOfClass:[SongControlView class]]) {
                [self.streamer stop];
                self.streamer = nil;
                [self.musicPlayer play];
             }
         }
     }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (AVAudioPlayer *)loadWav:(NSString *)filename {
    NSURL * url = [[NSBundle mainBundle] URLForResource:filename withExtension:@"mp3"];
    NSError * error;
    AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (!player) {
        NSLog(@"Error loading %@: %@", url, error.localizedDescription);
    } else {
        //[player prepareToPlay];
        player.delegate = self;
    }
    return player;
}

#pragma mark tabBarView Delegate Method

-(int)updateTheTabBarView{
    int index = 0;
    return index;
}

#pragma mark create a radio streaming..

- (void)createStreamerWith:(NSString *)radioStreamingUrl
{
    NSString *downloadSourceField= radioStreamingUrl;
	NSString *escapedValue =
    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                          nil,
                                                                          (CFStringRef)downloadSourceField,
                                                                          NULL,
                                                                          NULL,
                                                                          kCFStringEncodingUTF8))
    ;
	NSURL *url = [NSURL URLWithString:escapedValue];
	self.streamer = [[AudioStreamer alloc] initWithURL:url];
    
    [self.streamer start];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player stop];
    [self.musicPlayer play];
}

- (void)handle_NowPlayingItemChanged:(NSNotification*)note {
    //only when one song ends automatically.....
    self.notifyTimes++;
    if (self.whetherIsSwipe == NO && self.notifyTimes > 2 && [self.musicPlayer indexOfNowPlayingItem] > self.musicIndex) {
        CGRect currentFrame = ((UIImageView *)[self.songControlView.containerView.subviews objectAtIndex:(self.musicIndex)]).frame;
        currentFrame = CGRectMake(currentFrame.origin.x, 0, currentFrame.size.width, currentFrame.size.height);
        currentFrame.origin.y -= 255;
        CGRect nextFrame = ((UIImageView *)[self.songControlView.containerView.subviews objectAtIndex:(self.musicIndex+1)]).frame;
        nextFrame.origin.y = 0;
        
        //draw a customized progress bar
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                             ((UIView *)[self.songControlView.containerView.subviews objectAtIndex:(self.musicIndex)]).frame = currentFrame ;
                             ((UIView *)[self.songControlView.containerView.subviews objectAtIndex:(self.musicIndex+1)]).frame = nextFrame;
                             ((UIView *)[self.songControlView.containerView.subviews objectAtIndex:(self.musicIndex+1)]).alpha = 1;
                             ((UIView *)[self.songControlView.containerView.subviews objectAtIndex:(self.musicIndex)]).alpha = 0.2;
                             self.songControlView.songName.alpha = 0;
                             self.songControlView.author.alpha = 0;
                         }
                         completion:^(BOOL finished){
                           
                             self.musicIndex++;
                             
                             [self.songControlView.songName setText: [self.songControlView.songNameArray objectAtIndex:self.musicIndex]];
                             [self.songControlView.author setText:[self.songControlView.authorArray objectAtIndex:self.musicIndex]];
                             
                             [self.volumeControlView.author setText:[self.songControlView.authorArray objectAtIndex:self.musicIndex]];
                             [self.volumeControlView.songName setText: [self.songControlView.songNameArray objectAtIndex:self.musicIndex]];
                             
                             [UIView animateWithDuration:0.5
                                    delay:0
                                    options: UIViewAnimationCurveEaseInOut
                                    animations:^{
                                         self.songControlView.songName.alpha = 1;
                                         self.songControlView.author.alpha = 1;
                         }
                            completion:nil];
                             [self setMusicForVolumeView:[self.songControlView.albumImages objectAtIndex:self.musicIndex] withContent:@""];
                         }];
    }
}

-(void)checkViewIndex{
    CAKeyframeAnimation * anim1 = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim1.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)], [ NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f) ]];
    anim1.autoreverses = YES ;
    anim1.repeatCount = 1;
    anim1.duration = 0.3f ;
    //[self.musicMenuIcon.layer addAnimation:anim1 forKey:nil];
    if (self.subItemIconArray) {
        NSLog(@"there are %d in the array", [self.subItemIconArray count]);
        for (int i = 0; i < [self.subItemIconArray count]; i++) {
            if (i != self.currentViewIndex) {
                for (UIView *view in ((UIView *)[self.subItemIconArray objectAtIndex:i]).subviews) {
                    [UIView animateWithDuration:0.5
                                          delay:0
                                        options: UIViewAnimationCurveEaseInOut
                                     animations:^{
                                         view.alpha = 0.3;
                                                }
                                     completion:nil];
                }
            }
            else{
                for (UIView *view in ((UIView *)[self.subItemIconArray objectAtIndex:i]).subviews) {
                    [UIView animateWithDuration:0.5
                                          delay:0
                                        options: UIViewAnimationCurveEaseInOut
                                     animations:^{
                                         view.alpha = 1;
                                         [view.layer addAnimation:anim1 forKey:nil];
                                     }
                                     completion:nil
                     ];
                }
            }
        }
    }
}
@end

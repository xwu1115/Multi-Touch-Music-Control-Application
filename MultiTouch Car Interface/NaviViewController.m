//
//  NaviViewController.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/13/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "NaviViewController.h"

@interface NaviViewController ()

#define METERS_PER_MILE 1609.344
@property CLLocationManager*locationManager;
@property CLLocationCoordinate2D currentUserLocation;
@property CLGeocoder *geocoder;
@property CLPlacemark *placemark;
@property NSString* userAddress;
@property (weak, nonatomic)  UIView *roundCornerView;
@property (weak, nonatomic)  UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *menuImageIcon;
@property (weak, nonatomic) IBOutlet UIView *addRouteView;
@property (weak, nonatomic) IBOutlet UIView *deleteRouteView;
@property (weak, nonatomic) IBOutlet UIView *currentLocationView;
@property NSMutableArray *cardViewsArray;
@property int currentViewIndex;
@property NSMutableArray *subItems;
@property (weak, nonatomic) IBOutlet UIView *locationIcon;
@property (weak, nonatomic) IBOutlet UIView *addIcon;
@property (weak, nonatomic) IBOutlet UIView *deleteIcon;

@end

@implementation NaviViewController

@synthesize locationManager,currentUserLocation,geocoder,placemark,userAddress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:60/255.0 green:52/255.0 blue:52/255.0 alpha:1];
    self.mapView.delegate =self;

    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.cardViewsArray = [NSMutableArray array];
    [self.cardViewsArray addObject:self.currentLocationView];
    [self.cardViewsArray addObject:self.addRouteView];
    [self.cardViewsArray addObject:self.deleteRouteView];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeGestureLeft];
    [self.view addGestureRecognizer:swipeGestureRight];
    [self.view addGestureRecognizer:swipeGestureUp];
    [self.view addGestureRecognizer:swipeGestureDown];
    
    self.currentViewIndex = 0;
    
    self.subItems = [NSMutableArray array];
    [self.subItems addObject:self.locationIcon];
    [self.subItems addObject:self.addIcon];
    [self.subItems addObject:self.deleteIcon];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    CAKeyframeAnimation * anim1 = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim1.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2f, 0.2f, 1.0f)], [ NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f) ]];
    anim1.autoreverses = NO;
    anim1.repeatCount = 0;
    anim1.duration = .4f;

    [self.menuImageIcon.layer addAnimation:anim1 forKey:nil];
    
    for (int i = 0; i < [self.cardViewsArray count]; i++ ) {
        
        UIView *view = [self.cardViewsArray objectAtIndex:i];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        view.layer.shadowOffset = CGSizeMake(0, 5);
        view.layer.shadowRadius = 5;
        view.layer.shadowOpacity = 0.7;
        view.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.addRouteView.layer.bounds cornerRadius:4].CGPath;
        
        UIView *cornerView = [view.subviews firstObject];
        cornerView.layer.cornerRadius = 6;
        cornerView.layer.masksToBounds = YES;
        cornerView.backgroundColor = [UIColor colorWithRed:56/255.0 green:53/255.0 blue:53/255.0 alpha:1];
        
        CGRect currentFrame = view.frame;
        currentFrame.origin.x = 42+960*i;
        currentFrame.origin.y = 40;
        view.frame = currentFrame;
    }
    [self checkViewIndex];
}

-(void)checkViewIndex{
    
    CAKeyframeAnimation * anim1 = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim1.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)], [ NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f) ]];
    anim1.autoreverses = YES ;
    anim1.repeatCount = 1;
    anim1.duration = 0.3f ;
    //[self.musicMenuIcon.layer addAnimation:anim1 forKey:nil];
    if (self.subItems) {
        for (int i = 0; i < [self.subItems count]; i++) {
            if (i != self.currentViewIndex) {
                for (UIView *view in ((UIView *)[self.subItems objectAtIndex:i]).subviews) {
                    [UIView animateWithDuration:0.5
                                          delay:0
                                        options: UIViewAnimationCurveEaseInOut
                                     animations:^{
                                         view.alpha = 0.3;
                                     }
                                     completion:nil
                     ];
                }
            }
            else{
                for (UIView *view in ((UIView *)[self.subItems objectAtIndex:i]).subviews) {
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


-(void)updateLocation{
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentUserLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [locationManager startUpdatingLocation];
    geocoder=[[CLGeocoder alloc]init];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil)
    {
        currentUserLocation.latitude=currentLocation.coordinate.latitude;
        currentUserLocation.longitude=currentLocation.coordinate.longitude;
    }
    
    [locationManager stopUpdatingLocation];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            userAddress= [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                          placemark.subThoroughfare, placemark.thoroughfare,
                          placemark.postalCode, placemark.locality,
                          placemark.administrativeArea,
                          placemark.country];
            NSLog(@"%@",userAddress);
            self.addressLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
            self.addressLabel.text = userAddress;
            [self updateLocation];
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

#pragma mark handle gesture

-(void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
    if(gesture.direction == UISwipeGestureRecognizerDirectionRight || gesture.direction == UISwipeGestureRecognizerDirectionLeft){
        if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
            if (self.currentViewIndex < [self.cardViewsArray count]-1)
            {
                CGRect currentFrame = CGRectMake(42 - 1*960, 40, ((UIView *)[self.cardViewsArray objectAtIndex:self.currentViewIndex]).frame.size.width, ((UIView *)[self.cardViewsArray objectAtIndex:self.currentViewIndex]).frame.size.height);
                
                CGRect nextFrame = CGRectMake(42, 40, ((UIView *)[self.cardViewsArray objectAtIndex:self.currentViewIndex]).frame.size.width, ((UIView *)[self.cardViewsArray objectAtIndex:self.currentViewIndex]).frame.size.height);
                
                [UIView animateWithDuration:0.5
                                      delay:0
                                    options: UIViewAnimationCurveEaseInOut
                                 animations:^{
                                     
                                     self.currentViewIndex ++;
                                     [self checkViewIndex];
                                     ((UIView *)[self.cardViewsArray objectAtIndex:self.currentViewIndex-1]).frame = currentFrame;
                                     ((UIView *)[self.cardViewsArray objectAtIndex:(self.currentViewIndex)]).frame = nextFrame;
                                     
                                 }
                                 completion:^(BOOL finished){
                                 }];
                
            }
            else{
            }
        }
        if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
            
            if (self.currentViewIndex > 0)
            {
                CGRect currentFrame = CGRectMake(42 + 1*960, 40, ((UIView *)[self.cardViewsArray objectAtIndex:self.currentViewIndex]).frame.size.width, ((UIView *)[self.cardViewsArray objectAtIndex:self.currentViewIndex]).frame.size.height);
                
                CGRect nextFrame = CGRectMake(42, 40, ((UIView *)[self.cardViewsArray objectAtIndex:self.currentViewIndex]).frame.size.width, ((UIView *)[self.cardViewsArray objectAtIndex:self.currentViewIndex]).frame.size.height);
                
                [UIView animateWithDuration:0.5
                                      delay:0
                                    options: UIViewAnimationCurveEaseInOut
                                 animations:^{
                                     self.currentViewIndex --;
                                     [self checkViewIndex];
                                     ((UIView *)[self.cardViewsArray objectAtIndex:self.currentViewIndex+1]).frame = currentFrame;
                                     ((UIView *)[self.cardViewsArray objectAtIndex:(self.currentViewIndex)]).frame = nextFrame;
                                 }
                                 completion:^(BOOL finished){
                                 }];
            }
            else{
                CATransition* transition = [CATransition animation];
                transition.duration = 0.6;
                transition.type = kCATransitionFade;
                //transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:kCATransition];
                
                [self.tabBarController setSelectedIndex:0];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = NO;
        //aView.leftCalloutAccessoryView.frame = CGRectMake(0, 0, 100, 100);
        // could put a rightCalloutAccessoryView here
    }
    aView.annotation = annotation;
    //[(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    return aView;
}

-(int)updateTheTabBarView{
    return 2;
}

@end

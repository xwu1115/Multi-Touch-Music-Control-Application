//
//  NaviViewController.h
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 3/13/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TabBarView.h"
@interface NaviViewController : UIViewController<MKMapViewDelegate, TabBarViewDelegate>
@property (weak, nonatomic)  MKMapView *mapView;
@end

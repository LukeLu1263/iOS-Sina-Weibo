//
//  NearWeiboMapViewController.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-6-30.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NearWeiboMapViewController : BaseViewController<CLLocationManagerDelegate, MKMapViewDelegate>

@property(nonatomic, retain) NSArray *data;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@end

//
//  NearWeiboMapViewController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-6-30.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "NearWeiboMapViewController.h"
#import "DataService.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

@interface NearWeiboMapViewController ()

@end

@implementation NearWeiboMapViewController

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
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)loadNearWeiboData:(NSString *)lon latitude:(NSString *)lat {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:lon,@"long", lat, @"lat", nil];
    [DataService requestWithURL:@"place/nearby_timeline.json" params:params httpMethod:@"GET" completeBlock:^(id result) {
        [self loadDataFinish:result];
    }];
}

- (void)loadDataFinish:(NSDictionary *)result {
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (int i=0; i<statues.count; i++) {
        NSDictionary *statuesDic = [statues objectAtIndex:i];
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
        
        // 创建Annotation对象，添加到地图上
        WeiboAnnotation *weiboAnnotation = [[WeiboAnnotation alloc] initWithWeibo:weibo];
        [self.mapView performSelector:@selector(addAnnotation:) withObject:weiboAnnotation afterDelay:i*0.05];
        [weiboAnnotation release];
    }
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    
    [manager stopUpdatingLocation];
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
	MKCoordinateSpan span = {0.1, 0.1};
    MKCoordinateRegion region = {coordinate, span};
    [self.mapView setRegion:region animated:YES];
    
    if (self.data == nil) {
        NSString *lon = [NSString stringWithFormat:@"%f", coordinate.longitude];
        NSString *lat = [NSString stringWithFormat:@"%f", coordinate.latitude];
        [self loadNearWeiboData:lon latitude:lat];
    }
}

#pragma mark - MKAnnotationView delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identify = @"WeiboAnnotationView";
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identify];
    if (annotationView == nil) {
        annotationView = [[[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identify] autorelease];
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (UIView *annotationView in views) {
        
        // 0.7 ----> 1.2 ----> 1 动画大小
        CGAffineTransform transform = annotationView.transform;
        annotationView.transform = CGAffineTransformScale(transform, 0.7, 0.7);
        annotationView.alpha = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            //动画1
            annotationView.transform = CGAffineTransformScale(transform, 1.2, 1.2);
            annotationView.alpha = 1;
        } completion:^(BOOL finished) {
            //动画2
            [UIView animateWithDuration:0.5 animations:^{
                annotationView.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

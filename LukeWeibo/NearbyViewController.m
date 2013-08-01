//
//  NearbyViewController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-14.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "NearbyViewController.h"
#import "UIImageView+WebCache.h"
#import "DataService.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我在这里";
        
        // 放在[super viewDidLoad]之前
        self.isBackButton = NO;
        self.isCancelButton = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.hidden = YES;
    [super showLoading:YES];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager startUpdatingLocation];
    
    
}

#pragma mark - UI
- (void)refreshUI {
    self.tableView.hidden = NO;
    [super showLoading:NO];
    [self.tableView reloadData];
}

#pragma mark - data
- (void)loadNearbyDataFinish:(NSDictionary *)result {
    NSArray *pois = [result objectForKey:@"pois"];
    self.data = pois;
    
    [self refreshUI];
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    
    [manager stopUpdatingLocation];
    
    if (self.data == nil) {
        float longtitude = newLocation.coordinate.longitude;
        float latitude   = newLocation.coordinate.latitude;
        
        NSString *longString = [NSString stringWithFormat:@"%f", longtitude];
        NSString *latString  = [NSString stringWithFormat:@"%f", latitude];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       longString, @"long",
                                       latString, @"lat",
                                       @"20", @"count",
                                       nil];
//        [self.sinaweibo requestWithURL:URL_POIS
//                                params:params
//                            httpMethod:@"GET"
//                                 block:^(id result){
//                                     [self loadNearbyDataFinish:result];
//                                 }];
        
        //测试自己封装的请求
        [DataService requestWithURL:URL_POIS
                             params:params
                         httpMethod:@"GET"
                      completeBlock:^(id result) {
            [self loadNearbyDataFinish:result];
        }];
    }
    
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
    }
    
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *title   = [dic objectForKey:@"title"];
    NSString *address = [dic objectForKey:@"address"];
    NSString *icon    = [dic objectForKey:@"icon"];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = address;
    [cell.imageView setImageWithURL:[NSURL URLWithString:icon]];
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60; // defualt is 40.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectDoneBlock != nil) {
        NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
        _selectDoneBlock(dic);
        /**
         *  如果block只被调用一次，就可以在此释放掉，就不需要考虑循环引用问题.
         *  如果block会被多次调用，就需要在dealloc中调用， 但需要考虑循环引用问题.
         */
        Block_release(_selectDoneBlock);
        _selectDoneBlock = nil; // 在此需要安全释放，赋值为nil。 如果在dealloc中，就不需要安全释放。
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end

//
//  NearbyViewController.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-14.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^SelectDoneBlock) (NSDictionary *);

@interface NearbyViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (retain, nonatomic) NSArray *data;
@property (nonatomic, copy)   SelectDoneBlock selectDoneBlock;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end

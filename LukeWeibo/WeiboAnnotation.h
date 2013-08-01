//
//  WeiboAnnotation.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-6-30.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"

@interface WeiboAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
//@property (nonatomic, readonly, copy) NSString *title;
//@property (nonatomic, readonly, copy) NSString *subtitle;

@property (nonatomic, retain)WeiboModel *weiboModel;

- (id)initWithWeibo:(WeiboModel *)weibo;

@end

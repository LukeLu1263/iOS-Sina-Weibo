//
//  WeiboAnnotation.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-6-30.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

- (id)initWithWeibo:(WeiboModel *)weibo {
    self = [super init];
    if (self != nil) {
        self.weiboModel = weibo;
    }
    return self;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
    }
    
    //返回的字符串"null" 解析为 --> NSNull
    NSDictionary *geo = weiboModel.geo;
    if ([geo isKindOfClass:[NSDictionary class]]) {
        NSArray *coord = [geo objectForKey:@"coordinates"];
        if (coord.count == 2) {
            float lat = [[coord objectAtIndex:0] floatValue];
            float lon = [[coord objectAtIndex:1] floatValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
    }
}

@end

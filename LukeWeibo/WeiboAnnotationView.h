//
//  WeiboAnnotationView.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-6-30.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView {
    UIImageView *userImage;     // 用户头像
    UIImageView *weiboImage;    // 带图片的微博
    UILabel     *textLabel;     // 微博内容
}

@end

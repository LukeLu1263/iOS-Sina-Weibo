//
//  WeiboAnnotationView.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-6-30.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@implementation WeiboAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self initView];
    }
    return self;
}

- (void)initView {
    userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    userImage.layer.borderWidth = 1;
    
    weiboImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    weiboImage.backgroundColor = [UIColor blackColor];
//    weiboImage.contentMode = UIViewContentModeScaleAspectFit;
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.font = [UIFont systemFontOfSize:12.0];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 3;
    
    [self addSubview:weiboImage];
    [self addSubview:textLabel];
    [self addSubview:userImage];    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WeiboAnnotation *weiboAnnotation = self.annotation;
    WeiboModel *weibo = nil;
    if ([weiboAnnotation isKindOfClass:[WeiboAnnotation class]]) {
        weibo = weiboAnnotation.weiboModel;
    }
    
    NSString *thumbnailImage = weibo.thumbnailImage;
    if (thumbnailImage.length > 0) {
        //带微博视图
        self.image = [UIImage imageNamed:@"nearby_map_photo_bg.png"];
        
        // 加载微博图片
        weiboImage.frame = CGRectMake(15, 15, 90, 85);
        [weiboImage setImageWithURL:[NSURL URLWithString:thumbnailImage]];

        // 加载用户头像
        userImage.frame = CGRectMake(70, 70, 30, 30);
        NSString *userURL = weibo.user.profile_image_url;
        [userImage setImageWithURL:[NSURL URLWithString:userURL]];
        
        textLabel.hidden = YES;
        weiboImage.hidden = NO;
        
    } else {
        //不带微博视图
        self.image = [UIImage imageNamed:@"nearby_map_content.png"];

        // 加载用户图像
        userImage.frame = CGRectMake(20, 20, 45, 45);
        NSString *userURL = weibo.user.profile_image_url;
        [userImage setImageWithURL:[NSURL URLWithString:userURL]];

        //微博内容
        textLabel.frame = CGRectMake(userImage.right+5, userImage.top, 110, 45);
        textLabel.text = weibo.text;
        
        textLabel.hidden = NO;
        weiboImage.hidden = YES;
    }
}

@end

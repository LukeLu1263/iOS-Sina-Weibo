//
//  WeiboView.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-6.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#define kWeibo_Width_List       (ScreenWidth-60)    //微博在列表中的宽度
#define kWeibo_Width_Detail     (ScreenWidth-20)    //微博在详情页面的宽度

@class WeiboModel;
@class ThemeImageView;
@interface WeiboView : UIView <RTLabelDelegate> {
  @private
    RTLabel         *_textLabel;            // weibo content
    UIImageView     *_image;                // weibo image
    ThemeImageView  *_repostBackgroundView; // background of repost weibo
    WeiboView       *_repostView;           // repost weiboView
    NSMutableString *_parseText;
}

// 微博数据模型
@property(nonatomic, retain)WeiboModel      *weiboModel;
// 当前的微博视图，是否是转发的
@property(nonatomic, assign)BOOL            isRepost;
// 微博视图是否显示在详情页面
@property(nonatomic, assign)BOOL            isDetail;

// Get the font size
+ (CGFloat)getFontSize:(BOOL)isDetail
              isRepost:(BOOL)isRepost;

// Calculate the height of weiboView
+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                     isRepost:(BOOL)isRepost
                     isDetail:(BOOL)isDetail;

@end

//
//  WeiboCell.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-6.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboModel;
@class WeiboView;
@class WXImageView;
@interface WeiboCell : UITableViewCell {
    WXImageView         *_userImage;            // 用户头像视图
    UILabel             *_nickLabel;            // 昵称
    UILabel             *_repostCountLabel;     // 转发数
    UILabel             *_commentLabel;         // 评论数
    UILabel             *_sourceLabel;          // 发布来源
    UILabel             *_createLabel;          // 发布时间
    
}

@property(nonatomic, retain)WeiboModel *weiboModel;
@property(nonatomic, retain)WeiboView *weiboView;

@end

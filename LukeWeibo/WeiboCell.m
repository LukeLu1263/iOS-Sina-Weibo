//
//  WeiboCell.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-6.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "RegexKitLite.h"
#import "UserViewController.h"
#import "WXImageView.h"

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

// 初始化子视图
- (void)_initView {
    // 用户头像
    _userImage                      = [[WXImageView alloc] initWithFrame:CGRectZero];
    _userImage.backgroundColor      = [UIColor clearColor];
    _userImage.layer.cornerRadius   = 5; // 圆弧半径
    _userImage.layer.borderWidth    = .5;
    _userImage.layer.borderColor    = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds  = YES; 
    [self.contentView addSubview:_userImage];
    
    // 昵称
    _nickLabel                      = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLabel.backgroundColor      = [UIColor clearColor];
    _nickLabel.font                 = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_nickLabel];
    
    // 转发数
    _repostCountLabel                   = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.font              = [UIFont systemFontOfSize:12.0];
    _repostCountLabel.backgroundColor   = [UIColor clearColor];
    _repostCountLabel.textColor         = [UIColor blackColor];
    [self.contentView addSubview:_repostCountLabel];
    
    // 回复数
    _commentLabel                   = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font              = [UIFont systemFontOfSize:12.0];
    _commentLabel.backgroundColor   = [UIColor clearColor];
    _commentLabel.textColor         = [UIColor blackColor];
    [self.contentView addSubview:_commentLabel];
    
    // 微博来源
    _sourceLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.font            = [UIFont systemFontOfSize:12.0];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor       = [UIColor blackColor];
    [self.contentView addSubview:_sourceLabel];
    
    // 发布时间
    _createLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.font            = [UIFont systemFontOfSize:12.0];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor       = [UIColor blueColor];
    [self.contentView addSubview:_createLabel];
    
    _weiboView                   = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];

    // 设置cell的选中背景颜色
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)]; // 不用设置frame宽高,自动设置
    selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"statusdetail_cell_sepatator.png"]];
    self.selectedBackgroundView = selectedBackgroundView;
    [selectedBackgroundView release];
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
    }
    
    __block WeiboCell *weakSelf = self;
    _userImage.touchBlock = ^{
        NSString *nickName = weakSelf.weiboModel.user.screen_name;
        UserViewController *userCtrl = [[UserViewController alloc] init];
        userCtrl.userName = nickName;
        [weakSelf.viewController.navigationController pushViewController:userCtrl animated:YES];
        [userCtrl release];
    };
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    /////////////////////用户头像视图 _userImage///////////////////
    _userImage.frame = CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    // 昵称 _nickLabel
    _nickLabel.frame = CGRectMake(50, 5, 200, 20);
    _nickLabel.text = _weiboModel.user.screen_name;
    
    // 微博视图 _weiboView
    _weiboView.weiboModel = _weiboModel;
    // 获取微博视图的高度
    CGFloat h = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    _weiboView.frame = CGRectMake(50, _nickLabel.bottom+10, kWeibo_Width_List, h);

    // 调用WeiboView的重新布局方法
    [_weiboView setNeedsLayout]; // 6.0一下需要调用(由于6.0以下，复用cell的时候不会自己调用该方法)
    
    // 发布时间
    // 源日期字符串:Tue May 31 17:46:55 +0800 2011
    //            E M d HH:mm:ss Z yyyy
    // 目标日期字符串 5-31 17:46
    NSString *createData = _weiboModel.createDate;
    if (createData) {
        _createLabel.hidden = NO;
        NSString *dateString = [UIUtils fomateString:createData];
        _createLabel.text = dateString;
        _createLabel.frame = CGRectMake(50, self.height-20, 100, 20);
        [_createLabel sizeToFit];
    } else {
        _createLabel.hidden = YES;
    }
    
    // 微博来源
    NSString *source = _weiboModel.source;
    //<a href="http://weibo.com" rel="nofollow">新浪微博</a>
    NSString *ret = [self parseSource:source];
    if (ret) {
        _sourceLabel.hidden = NO;
        _sourceLabel.text   = [NSString stringWithFormat:@"来自%@", ret];
        _sourceLabel.frame  = CGRectMake(_createLabel.right+8, _createLabel.top, 100, 20);
        [_sourceLabel sizeToFit];
    } else {
        _sourceLabel.hidden = YES;
    }
    
}

- (NSString *)parseSource:(NSString *)source {
    NSString *regex = @">\\w+<";
    NSArray *array = [source componentsMatchedByRegex:regex];
    if (array.count > 0) {
        // >新浪微博<
        NSString *ret = [array objectAtIndex:0];
        NSRange range;
        range.location = 1;
        range.length = ret.length-2;
        NSString *resultString = [ret substringWithRange:range];
        return resultString;
    }
    return nil;
}

@end

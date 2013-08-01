//
//  HomeViewController.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@class ThemeImageView;
@interface HomeViewController : BaseViewController <SinaWeiboRequestDelegate, UITableViewEventDelegate>
{
    ThemeImageView *_barView;
}
@property (nonatomic, retain) WeiboTableView *tableView;
@property (nonatomic, copy)   NSString       *topWeiboId;       // tableView顶部微博id
@property (nonatomic, copy)   NSString       *lastWeiboId;      // tableView底部微博id
@property (nonatomic, retain) NSMutableArray *weibos;

// 触发下拉刷新微博
- (void)refreshWeibo;
- (void)loadWeiboData;
@end

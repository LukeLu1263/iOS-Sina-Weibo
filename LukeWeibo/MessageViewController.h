//
//  MessageViewController.h
//  LukeWeibo
//  消息首页控制器
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@interface MessageViewController : BaseViewController<UITableViewEventDelegate> {
    WeiboTableView *_weiboTableView;
}

@end

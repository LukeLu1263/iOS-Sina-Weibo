//
//  UserViewController.h
//  LukeWeibo
//  个人中心
//  Created by Luke Lu on 13-4-11.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@class UserInfoView;
@interface UserViewController : BaseViewController <UITableViewEventDelegate> {
    NSMutableArray *_requests;
}

@property (nonatomic, copy) NSString *userName; // screen_name, 传入该数据，进入该用户主页
@property (nonatomic, copy) NSString *userId;   
@property (nonatomic, assign) BOOL showLoginUser;

@property (nonatomic, retain) UserInfoView *userInfoView;
@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;

@end
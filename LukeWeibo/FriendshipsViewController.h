//
//  FriendshipsViewController.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-16.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendshipsTableView.h"

//typedef enum {
//    Attention,  //关注列表
//    Fans        //粉丝列表
//}FriendshipsType;

typedef NS_ENUM(NSInteger, FriendshipsType) {
    Attention = 100,  //关注列表
    Fans        //粉丝列表
};

@interface FriendshipsViewController : BaseViewController<UITableViewEventDelegate>

@property(nonatomic, copy)NSString *userId;
@property(nonatomic, retain)NSMutableArray *data;

// 下一页的游标
@property(nonatomic, copy)NSString *cursor;
@property(nonatomic, assign)FriendshipsType shipType;

@property (retain, nonatomic) IBOutlet FriendshipsTableView *tableView;

@end

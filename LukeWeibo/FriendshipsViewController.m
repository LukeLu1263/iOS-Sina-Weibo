//
//  FriendshipsViewController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-16.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "FriendshipsViewController.h"
#import "DataService.h"
#import "UserModel.h"

@interface FriendshipsViewController ()

@end

@implementation FriendshipsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.data = [NSMutableArray array];
    self.tableView.eventDelegate = self;
    [super showLoading:YES];
    
    if (self.shipType == Fans) {
        self.title = @"粉丝数";
        [self loadData:URL_FOLLOWERS];
    }
    else if (self.shipType == Attention)
    {
        self.title = @"关注数";
        [self loadData:URL_FRIENDS];
    }
}

// 加载粉丝列表数据
- (void)loadData:(NSString *)url {
    if (self.userId.length == 0) {
        NSLog(@"用户id为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userId forKey:@"uid"];
    
    // curso int 返回结果的游标，下一页用返回值里的next_cursor，上一页用previous_cursor，默认为0。
    if (self.cursor.length > 0) {
        [params setObject:self.cursor forKey:@"cursor"];
    }
    
    [DataService requestWithURL:url
                         params:params
                     httpMethod:@"GET"
                  completeBlock:^(id result) {
                      [self loadDataFinish:result];
                  }];
}

- (void)loadDataFinish:(NSDictionary *)result {
    [super showLoading:NO];
    
    NSArray *usersArray = [result objectForKey:@"users"];
    /**
     *[
     *  ["user1", "user2", "user3"]
     *  ["user1", "user2", "user3"] <-- array2D.count < 3 [0~3]
     *  ["user1", "user2"],
     *  ...
     *];
     */
    
    NSMutableArray *array2D = nil;
    for (int i=0; i<usersArray.count; i++) {
        array2D = [self.data lastObject];
        
        // 每次判断最后一个数组是否填满
        if (array2D.count == 3 || array2D == nil) {
            array2D = [NSMutableArray arrayWithCapacity:3];
            [self.data addObject:array2D];
        }
        
        NSDictionary *userDic = [usersArray objectAtIndex:i];
        UserModel *userModel = [[UserModel alloc] initWithDataDic:userDic];
        [array2D addObject:userModel];
        [userModel release];
    }
    
    // 刷新UI
    if (usersArray.count < 40) {  //返回的个数不一定为50个
        self.tableView.isMore = NO;
    } else {
        self.tableView.isMore = YES;
    }
    
    self.tableView.data = self.data;
    [self.tableView reloadData];

    // 收起下拉
    if (self.cursor == nil) {
        [self.tableView doneLoadingTableViewData];
    }
    
    // 记录下一页的游标
    self.cursor = [[result objectForKey:@"next_cursor"] stringValue];
}

// BUG：如果cell没有全部复用完，下拉会出现NSArray越界的情况.
// 下拉
- (void)pullDown:(BaseTableView *)tableView {
    self.cursor = nil;
    [self.data removeAllObjects];
    if (self.shipType == Fans) {
        [self loadData:URL_FOLLOWERS];
    }
    else if (self.shipType == Attention) {
        [self loadData:URL_FRIENDS];
    }
}
// 上拉
- (void)pullUp:(BaseTableView *)tableView {
    if (self.shipType == Fans) {
        [self loadData:URL_FOLLOWERS];
    }
    else if (self.shipType == Attention) {
        [self loadData:URL_FRIENDS];
    }
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end

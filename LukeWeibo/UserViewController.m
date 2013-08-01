//
//  UserViewController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-11.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoView.h"
#import "UIFactory.h"
#import "UserModel.h"
#import "WeiboModel.h"
#import "UIFactory.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人资料";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _requests = [[NSMutableArray alloc] init];
    
    if (self.showLoginUser) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        NSString *userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        self.userId = userID;
    }
    
    self.userInfoView = [[[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)] autorelease];
    
    // homeButton
    UIButton *homeButton = [UIFactory createButtonWithBackground:@"tabbar_home.png" backgroundHighlighted:@"tabbar_home_highlighted.png"];
    homeButton.frame = CGRectMake(0, 0, 34, 27);
    [homeButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = homeItem;
    [homeItem release];
    
    // 没有数据之前隐藏空的表视图，数据加载之后显示表示图
    self.tableView.hidden = YES;
    self.tableView.eventDelegate = self;
    [self showLoading:YES];
    
    [self loadUserData];
    [self loadWeiboData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (SinaWeiboRequest *request in _requests) {
        // 取消请求
        [request disconnect];
    }
}

#pragma mark - data
// 加载用户资料
- (void)loadUserData {
    if (self.userName.length == 0 && self.userId.length == 0) {
        NSLog(@"error:用户为空!");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.userId.length) {
        [params setObject:self.userId forKey:@"uid"];
    } else {
        [params setObject:self.userName forKey:@"screen_name"];
    }
    
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"users/show.json"
                                                        params:params
                                                    httpMethod:@"GET"
                                                         block:^(id result) {
                                                             [self loadUserDataFinish:result];
                                                         }];
    [_requests addObject:request];
    
}

- (void)loadUserDataFinish:(NSDictionary *)result {
    UserModel *userModel = [[UserModel alloc] initWithDataDic:result];
    self.userInfoView.user = userModel;
    [self refreshUI];
}

// 获取用户最新发表的微博列表
- (void)loadWeiboData {
    if (self.userName.length == 0 && self.userId.length == 0) {
        NSLog(@"error:用户为空!");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.userId.length) {
        [params setObject:self.userId forKey:@"uid"];
    } else {
        [params setObject:self.userName forKey:@"screen_name"];
    }
    
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"statuses/user_timeline.json"
                                                        params:params
                                                    httpMethod:@"GET"
                                                         block:^(id result) {
                                                             [self loadWeiboDataFinish:result];
                                                         }];
    [_requests addObject:request];
}

- (void)loadWeiboDataFinish:(NSDictionary *)result {
    NSArray *statuses = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
    for (NSDictionary *dic in statuses) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
        [weibos addObject:weiboModel];
        [weiboModel release];
    }
    
    self.tableView.data = weibos;
    if (weibos.count >= 20) {
        self.tableView.isMore = YES;
    }
    else {
        self.tableView.isMore = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark - BaseTableView delegate
// 下拉
- (void)pullDown    :(BaseTableView *)tableView {
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2];
}
// 上拉
- (void)pullUp      :(BaseTableView *)tableView {
    [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2];
}

#pragma mark - actions
- (void)goHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UI
- (void)refreshUI {
    [super showLoading:NO];
    self.tableView.hidden = NO;
    self.tableView.tableHeaderView = _userInfoView;
}

#pragma memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

@end

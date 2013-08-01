//
//  HomeViewController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "UIFactory.h"
#import "MainViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "CONSTS.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"微博";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //绑定按钮
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = bindItem;
    [bindItem release];
    
    //注销按钮
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(logoutAction:)];
    self.navigationItem.leftBarButtonItem = logoutItem;
    [logoutItem release];
    
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-49-44) style:UITableViewStylePlain];
    _tableView.eventDelegate = self;
    // 没有数据之前隐藏空的表视图，数据加载之后显示表示图
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    if (self.sinaweibo.isAuthValid) {
        //加载微博列表
        [self loadWeiboData];
    }
    else {
        // 登陆
        [self.sinaweibo logIn];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 开启左滑、右滑菜单
    [self.appDelegate.menuCtrl setEnableGesture:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 禁用左滑、右滑菜单
    [self.appDelegate.menuCtrl setEnableGesture:NO];
}

#pragma mark - UI
// 显示新微博数量
- (void)showNewWeiboCount:(int)count {
    if (_barView == nil) {
        _barView = [[UIFactory createImageView:@"timeline_new_status_background.png"] retain];
        _barView.leftCapWidth = 5;
        _barView.topCapHeight = 5;
        _barView.frame = CGRectMake(5, -40, ScreenWidth-10, 40);
        [self.view addSubview:_barView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 2013;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [_barView addSubview:label];
        [label release];
    }

    if (count > 0) {
        UILabel *label = (UILabel *)[_barView viewWithTag:2013];
        label.text = [NSString stringWithFormat:@"%d条新微博", count];
        [label sizeToFit];
        label.origin = CGPointMake((_barView.width-label.width)/2, (_barView.height-label.height)/2);
        
        [UIView animateWithDuration:0.6 animations:^{
            _barView.top = 5;
        } completion:^(BOOL finished){
            if (finished) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:1];
                [UIView setAnimationDuration:0.6];
                _barView.top = -40;
                [UIView commitAnimations];
            }
        }];
        
        // 播放提示声音
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundId);
        AudioServicesPlaySystemSound(soundId);
    }
    
    // 隐藏未读图标
    MainViewController *mainCtrl = (MainViewController *)self.tabBarController;
    [mainCtrl showBadge:NO];
    
}

#pragma mark - load data
- (void)loadWeiboData {
    // 显示加载提示
    //[super showLoading:YES]; // 系统自带
    [super showHUD:@"Loading..." isDim:YES]; // 第三方提示控件
    
    /**
     *  count:单页返回的记录条数，最大不超过100，默认为20
     **/
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:RequestCount forKey:@"count"];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}

// 下拉加载最新微博数据
- (void)pullDownData {
    if (self.topWeiboId.length == 0) {
        NSLog(@"log:topWeiboId为空");
        return;
    }
    /*
     *  since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     *  count       false	int     单页返回的记录条数，最大不超过100，默认为20。
     */

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:RequestCount, @"count", self.topWeiboId, @"since_id", nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result){
                                 [self pullDownDataFinish:result];
                             }];
}

- (void)pullDownDataFinish:(id)result {
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [array addObject:weibo];
        [weibo release];
    }
    
    // 更新topWeibo id
    if (array.count > 0) {
        WeiboModel *topWeibo = [array objectAtIndex:0];
        self.topWeiboId = [topWeibo.weiboId stringValue];
    }
    
    [array addObjectsFromArray:self.weibos];
    self.weibos = array;
    self.tableView.data = array;
    
    // 刷新TableView
    [self.tableView reloadData];
    // 收回下拉
    [self.tableView doneLoadingTableViewData];
    
    
    // 显示更新的微博数(显示未读微博数)
    int updateCount = [statues count];
    [self showNewWeiboCount:updateCount];
}

// 上拉加载更多
- (void)pullUpData {
    if (self.lastWeiboId.length == 0) {
        NSLog(@"log:LastWeiboId为空");
        return;
    }
    /*
     *  max_id      false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     *  count       false	int     单页返回的记录条数，最大不超过100，默认为20。
     */
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:RequestCount, @"count", self.lastWeiboId, @"max_id", nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result){
                                 [self pullUpDataFinish:result];
                             }];
}

- (void)pullUpDataFinish:(NSDictionary *)result {
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:statues.count];
    int count = 0;
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        count++;
        // max_id返回小于或者等于的微博，去掉重复的
        if (count == 1) {
            continue;
        }
        [array addObject:weibo];
        [weibo release];
    }
    
    // 更新lastWeibo id
    if (array.count > 0) {
        WeiboModel *lastWeibo = [array lastObject];
        self.lastWeiboId = [lastWeibo.weiboId stringValue];
    }

    [self.weibos addObjectsFromArray:array];

    // refresh UI
    if (statues.count >= [RequestCount intValue]) {
        self.tableView.isMore = YES;
    } else {
        self.tableView.isMore = NO;
    }
    self.tableView.data = self.weibos;
    [self.tableView reloadData];
}

// trriger:触发下拉刷新微博
- (void)refreshWeibo {
    // trigger pullToRefresh
    [self.tableView refreshData];
    self.tableView.hidden = NO;
    // 取数据
    [self pullDownData];
}

#pragma mark - SinaWeiboRequest delegate
//load network failed
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"网络加载失败:%@", error);
}

//load network successfully
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    // 隐藏加载提示
    //[super showLoading:NO];
    [super hideHUD]; //第三方HUD
    self.tableView.hidden = NO;
    
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    } 
    
    self.tableView.data = weibos;
    self.weibos = weibos;
    
    if (weibos.count > 0) {
        WeiboModel *topWeibo = weibos[0];
        self.topWeiboId = [topWeibo.weiboId stringValue];

        WeiboModel *lastWeibo = [weibos lastObject];
        self.lastWeiboId = [lastWeibo.weiboId stringValue];
    }

    // refresh UI
    if (statues.count >= [RequestCount intValue]) {
        self.tableView.isMore = YES;
    } else {
        self.tableView.isMore = NO;
    }

    [self.tableView reloadData];
}


#pragma mark - UITableViewEvent delegate (BaseTableView delegate)
// 下拉
- (void)pullDown:(BaseTableView *)tableView {
    [self pullDownData];
}
// 上拉
- (void)pullUp:(BaseTableView *)tableView {
    [self pullUpData];
}

#pragma mark - actions
- (void)bindAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logIn];
}

- (void)logoutAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logOut];
}

#pragma mark - Memery manger
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_topWeiboId release];
    [_lastWeiboId release];
    [_weibos release];
    [super dealloc];
}

- (void)viewDidUnload {
    
}

@end

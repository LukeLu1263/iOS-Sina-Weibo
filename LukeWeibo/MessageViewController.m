//
//  MessageViewController.m
//  LukeWeibo
//  消息首页控制器
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "MessageViewController.h"
#import "UIFactory.h"
#import "WeiboModel.h"
#import "DataService.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initView];
    [self loadAtWeiboData];
}

- (void)_initView {
    _weiboTableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44-49)
                                                      style:UITableViewStylePlain];
    _weiboTableView.eventDelegate = self;
    [self.view addSubview:_weiboTableView];
    _weiboTableView.hidden = YES;
    
    NSArray *messageButtons = [NSArray arrayWithObjects:
                               @"navigationbar_mentions.png",
                               @"navigationbar_comments.png",
                               @"navigationbar_messages.png",
                               @"navigationbar_notice.png",
                               nil];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    for (int i=0; i < messageButtons.count; i++) {
        NSString *imageName = [messageButtons objectAtIndex:i];
        UIButton *button = [UIFactory createButton:imageName highlighted:imageName];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(50*i+15, 10, 22, 22);
        
        [button addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [titleView addSubview:button];
    }
    
    self.navigationItem.titleView = [titleView autorelease];
}

- (void)messageAction:(UIButton *)button {
    int tag = button.tag;
    if (tag == 100) {
        [self loadAtWeiboData];
    } else if (tag == 101) {
        
    } else if (tag == 102) {
        
    } else if (tag == 103) {

    }
}

- (void)loadAtWeiboData {
    [super showLoading:YES];
    
    [DataService requestWithURL:@"statuses/mentions.json" params:nil httpMethod:@"GET" completeBlock:^(id result) {
        [self loadAtWeiboDataFinish:result];
    }];
}

- (void)loadAtWeiboDataFinish:(NSDictionary *)result {
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    // refresh UI
    [super showLoading:NO];
    _weiboTableView.hidden = NO;
    _weiboTableView.data = weibos;
    [_weiboTableView reloadData];
    
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
// 选中一个cell
- (void)tableView   :(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

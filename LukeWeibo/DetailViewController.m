//
//  DetailViewController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-9.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "CommentModel.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

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
    
    [self _initView];
    [self loadData];
}

- (void)_initView {
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    NSString *userImageurl = _weiboModel.user.profile_image_url;
    self.userImage.layer.cornerRadius = 5;
    self.userImage.layer.masksToBounds = YES;
    [self.userImage setImageWithURL:[NSURL URLWithString:userImageurl]];
    self.nickNameLabel.text = _weiboModel.user.screen_name;
    
    [tableHeaderView addSubview:self.userBarView];
    
    tableHeaderView.height += 60;
    
    //--------------------创建微博视图------------------------
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:YES];
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(10, _userBarView.bottom+10, ScreenWidth-20, h)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _weiboModel;
    
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height += (h+10);
    
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.eventDelegate = self;
    [tableHeaderView release];
}

- (void)loadData {
    NSString *weiboId = [_weiboModel.weiboId stringValue];
    if (weiboId.length == 0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboId forKey:@"id"];
    [self.sinaweibo requestWithURL:@"comments/show.json"
                            params:params
                        httpMethod:@"GET" 
                             block:^(NSDictionary *ret) {
                                 [self loadDataFinish:ret];
                             }];
}

- (void)loadDataFinish:(NSDictionary *)ret {
    NSArray *array = [ret objectForKey:@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dic];
        [comments addObject:commentModel];
        [CommentModel release];
    }
    
    if (array.count >= 20) {
        self.tableView.isMore = YES;
    } else {
        self.tableView.isMore = NO;
    }
    
    self.tableView.data = comments;
    self.tableView.commentDic = ret;
    [self.tableView reloadData];
}


#pragma mark - BaseTableView delegate
// 下拉
- (void)pullDown:(BaseTableView *)tableView {
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2];
}

// 上拉
- (void)pullUp:(BaseTableView *)tableView {
    [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2];
}

// 选中一个cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_userImage release];
    [_nickNameLabel release];
    [_userBarView release];
    [super dealloc];
}
@end

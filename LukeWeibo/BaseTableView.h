//
//  BaseTableView.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-8.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class BaseTableView;

@protocol UITableViewEventDelegate <NSObject>

@optional
// 下拉
- (void)pullDown:(BaseTableView *)tableView;
// 上拉
- (void)pullUp:(BaseTableView *)tableView;
// 选中一个cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BaseTableView : UITableView <EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIButton *_moreButton;
}

@property(nonatomic, assign)BOOL    refreshHeaderEnabled;   //是否需要下拉效果
@property(nonatomic, retain)NSArray *data;                  //为tableView提供数据
@property(nonatomic, assign)id <UITableViewEventDelegate> eventDelegate;

@property(nonatomic, assign)BOOL    isMore;                 //是否还有更多(下一页)

- (void)doneLoadingTableViewData;
// refresh tableView
- (void)refreshData;
@end

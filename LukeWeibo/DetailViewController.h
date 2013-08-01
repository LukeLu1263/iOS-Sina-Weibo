//
//  DetailViewController.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-9.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentTableView.h"

@interface DetailViewController : BaseViewController<UITableViewEventDelegate> {
    WeiboView *_weiboView;
}

@property(nonatomic, retain) WeiboModel *weiboModel;

@property (retain, nonatomic) IBOutlet CommentTableView *tableView;
@property (retain, nonatomic) IBOutlet UIImageView *userImage;
@property (retain, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (retain, nonatomic) IBOutlet UIView *userBarView;

@end

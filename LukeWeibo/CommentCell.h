//
//  CommentCell.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-9.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "WXImageView.h"
#import "CommentModel.h"

@interface CommentCell : UITableViewCell <RTLabelDelegate>{
    WXImageView *_userImage;
    UILabel *_nickNameLabel;
    UILabel *_timeLabel;
    RTLabel *_contentLabel;
}

@property(nonatomic, retain)CommentModel *commentModel;

// 计算评论cell的高度
+ (float)getCommentCellHeight:(CommentModel *)commentModel;

@end

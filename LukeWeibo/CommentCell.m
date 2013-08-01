//
//  CommentCell.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-9.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "UserViewController.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// 通过tag值实现拿到xib中的view的实例，UserInfoView是通过连线的方式拿到view的实例,userInfoView的方式更方便
- (void)awakeFromNib {
    _userImage = [(WXImageView *)[self viewWithTag:100] retain];
    [_userImage addTapGestrueRecognizer];
    _userImage.layer.cornerRadius = 5;
    _userImage.layer.masksToBounds = YES;
    _userImage.userInteractionEnabled = YES;
    
    _nickNameLabel = [(UILabel *)[self viewWithTag:101] retain];
    
    _timeLabel = [(UILabel *)[self viewWithTag:102] retain];
    
    _contentLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.delegate = self;
    _contentLabel.linkAttributes         = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    _contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self.contentView addSubview:_contentLabel];
}

- (void)setCommentModel:(CommentModel *)commentModel {
    if (_commentModel != commentModel) {
        [_commentModel release];
        _commentModel = [commentModel retain];
    }

    __block CommentCell *weakSelf = self;
    _userImage.touchBlock = ^{
        NSString *nickName = weakSelf.commentModel.user.screen_name;
        UserViewController *userCtrl = [[UserViewController alloc] init];
        userCtrl.userName = nickName;
        [weakSelf.viewController.navigationController pushViewController:userCtrl animated:YES];
        [userCtrl release];
    };
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *urlstring = self.commentModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:urlstring]];
    
    _nickNameLabel.text = self.commentModel.user.screen_name;
    _timeLabel.text = [UIUtils fomateString:self.commentModel.created_at];
    
    NSString *commentText = self.commentModel.text;
    // 解析替换超链接
    commentText = [UIUtils parseLink:commentText];
    _contentLabel.frame = CGRectMake(_userImage.right+10, _nickNameLabel.bottom+5, 240, 999);// 此处高任意
    _contentLabel.text = commentText;
    _contentLabel.height = _contentLabel.optimumSize.height;
}

+ (float)getCommentCellHeight:(CommentModel *)commentModel {
    RTLabel *rt = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    rt.font = [UIFont systemFontOfSize:14.0f];
    rt.text = commentModel.text;
    return rt.optimumSize.height;
}

#pragma mark - RTLabel delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    
}

@end

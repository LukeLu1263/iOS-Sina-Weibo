//
//  UserInfoView.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-11.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "UserInfoView.h"
#import "RectButton.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "FriendshipsViewController.h"

@implementation UserInfoView

// 通过连线的方式拿到xib中的view,CommentCell是通过tag值实现拿到xib中的view的实例
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil] lastObject];
        view.backgroundColor = Color(245, 245, 245, 1);
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 头像图片
    NSString *urlString = self.user.avatar_large;
    [self.userImageView setImageWithURL:[NSURL URLWithString:urlString]];
    self.userImageView.layer.cornerRadius = 5;
    self.userImageView.layer.masksToBounds = YES;

    
    // 昵称
    self.nameLabel.text = self.user.screen_name;
    
    // 性别
    NSString *gender = self.user.gender;
    NSString *sexName = @"未知";
    if ([gender isEqualToString:@"m"]) {
        sexName = @"男";
    }
    else if ([gender isEqualToString:@"f"]) {
        sexName = @"女";
    }
    
    // 地址
    NSString *location = self.user.location;
    if (location == nil) {
        location = @"";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",sexName, location];
    
    // 简介
    self.infoLabel.text = (self.user.description == nil) ? @"" : self.user.description;
    
    // 微博数
    NSString *count = [self.user.statuses_count stringValue];
    self.countLabel.text = [NSString stringWithFormat:@"共%@条微博", count];

    // 关注数
    self.atButton.title = @"关注";
    self.atButton.subtitle = [self.user.friends_count stringValue];
    
    // 粉丝数
    self.fansButton.title = @"粉丝";
    long fansCount = [self.user.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld", fansCount];
    if (fansCount >= 10000) {
        fansCount = fansCount/10000;
        fans = [NSString stringWithFormat:@"%ld万", fansCount];
    }
    self.fansButton.subtitle = fans;
}

- (void)dealloc {
    [_userImageView release];
    [_nameLabel release];
    [_addressLabel release];
    [_infoLabel release];
    [_countLabel release];
    [_atButton release];
    [_fansButton release];
    [super dealloc];
}

- (IBAction)AtAction:(id)sender {
    FriendshipsViewController *friendCtrl = [[FriendshipsViewController alloc] init];
    friendCtrl.userId = self.user.idstr;
    friendCtrl.shipType = Attention;
    [self.viewController.navigationController pushViewController:friendCtrl animated:YES];
    [friendCtrl release];
}

- (IBAction)fansAction:(id)sender {
    FriendshipsViewController *friendCtrl = [[FriendshipsViewController alloc] init];
    friendCtrl.userId = self.user.idstr;
    friendCtrl.shipType = Fans;
    [self.viewController.navigationController pushViewController:friendCtrl animated:YES];
    [friendCtrl release];
}
@end

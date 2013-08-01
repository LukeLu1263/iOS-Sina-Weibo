//
//  UserGridView.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-16.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "UserGridView.h"
#import "UIButton+WebCache.h"
#import "UserViewController.h"

@implementation UserGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *gridView = [[[NSBundle mainBundle] loadNibNamed:@"UserGridView" owner:self options:nil] lastObject];
        self.size = gridView.size;
        gridView.backgroundColor = [UIColor clearColor];
        [self addSubview:gridView];
        
        UIImage *image = [UIImage imageNamed:@"profile_button3_1.png"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:image];
        backgroundView.frame = self.bounds;
        [self insertSubview:backgroundView atIndex:0];
        [backgroundView release];
    }
    return self;
}

- (void)dealloc {
    [_nickNameLabel release];
    [_nickNameLabel release];
    [_fansLabel release];
    [_imageButton release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 昵称
    self.nickNameLabel.text = _userModel.screen_name;
    
    // 粉丝数
    long fansCount = [self.userModel.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld", fansCount];
    if (fansCount >= 10000) {
        fansCount = fansCount/10000;
        fans = [NSString stringWithFormat:@"%ld万", fansCount];
    }
    self.fansLabel.text = fans;
    
    //用户头像
    NSString *urlString = self.userModel.profile_image_url;
    [self.imageButton setImageWithURL:[NSURL URLWithString:urlString]];    
}

- (IBAction)userImageAction:(UIButton *)sender {
    UserViewController *userCtrl = [[UserViewController alloc] init];
    userCtrl.userId = self.userModel.idstr;
    
    [self.viewController.navigationController pushViewController:userCtrl animated:YES];
    [userCtrl release];
}
@end

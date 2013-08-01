//
//  RectButton.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-11.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>

//关注数、粉丝数按钮
@interface RectButton : UIButton {
    UILabel *_rectTitleLabel;
    UILabel *_subtitleLabel;
}

//标题
@property(nonatomic,copy)NSString *title;
//副标题
@property(nonatomic,copy)NSString *subtitle;


@end
//
//  WXImageView.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-12.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "WXImageView.h"

@implementation WXImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加相应点击事件
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:singleTap];
        [singleTap release];
    }
    return self;
}

- (void)addTapGestrueRecognizer {
    // 添加相应点击事件
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:singleTap];
    [singleTap release];
}

#pragma mark - actions
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.touchBlock) {
        _touchBlock();
    }
}

- (void)dealloc
{
    Block_release(_touchBlock);
    [super dealloc];
}

@end


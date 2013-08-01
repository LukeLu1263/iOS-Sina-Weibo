//
//  RectButton.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-11.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "RectButton.h"

@implementation RectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        [_title release];
        _title = [title copy];
    }
    
    [self setTitle:nil forState:UIControlStateNormal];
    
    if (_rectTitleLabel == nil) {
        _rectTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rectTitleLabel.backgroundColor = [UIColor clearColor];
        _rectTitleLabel.font = [UIFont systemFontOfSize:18.0f];
        _rectTitleLabel.textColor = [UIColor blackColor];
        _rectTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rectTitleLabel];
    }
}

- (void)setSubtitle:(NSString *)subtitle {
    if (_subtitle != subtitle) {
        [_subtitle release];
        _subtitle = [subtitle copy];
    }
    
    [self setTitle:nil forState:UIControlStateNormal];
    
    if (_subtitleLabel == nil) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:18.0f];
        _subtitleLabel.textColor = [UIColor blueColor];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subtitleLabel];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_subtitle != nil) {
        _subtitleLabel.text = _subtitle;
        _subtitleLabel.frame = CGRectMake(0, 15, self.width, 20);
    }
    
    if (_title != nil) {
        _rectTitleLabel.text = _title;
        _rectTitleLabel.frame = CGRectMake(0, _subtitleLabel.bottom, self.width, 20);
    }
}

@end

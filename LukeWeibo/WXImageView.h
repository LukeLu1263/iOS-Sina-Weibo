//
//  WXImageView.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-12.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock) (void);

@interface WXImageView : UIImageView

@property (nonatomic, copy) ImageBlock touchBlock;

- (id)initWithFrame:(CGRect)frame;
- (void)addTapGestrueRecognizer;

@end

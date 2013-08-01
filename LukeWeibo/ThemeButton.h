//
//  ThemeButton.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *highlightImageName;

@property(nonatomic, copy) NSString *backgroundImageName;
@property(nonatomic, copy) NSString *backgroundHighlightImageName;

// 设置图片拉伸的位置
@property(nonatomic, assign) int leftCapWidth;   // 横向离原点的位置
@property(nonatomic, assign) int topCapHeight;   // y左边离原点的拉伸位置

- (id)initWithImage:(NSString *)imageName highlighted:(NSString *)highlightImageName;
- (id)initWithBackground:(NSString *)backgroundImageName highlightedBackground:(NSString *)backgroundHighlightImageName;

@end

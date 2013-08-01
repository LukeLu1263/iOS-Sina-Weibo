//
//  UIView+Additions.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-11.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

// 遍历事件响应者链,知道找到UIViewController
- (UIViewController *)viewController;

@end

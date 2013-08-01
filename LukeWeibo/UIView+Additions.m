//
//  UIView+Additions.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-11.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (UIViewController *)viewController {
    
    UIResponder *next = [self nextResponder];

    // 下一个responder
    do {
        if ([next isKindOfClass:[UIViewController class]] ) {
            return (UIViewController *)next;
        }
    
        next = [next nextResponder];
    
    } while (next);

    return nil;
}

@end

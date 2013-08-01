//
//  ThemeLabel.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-5.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeLabel : UILabel

@property(nonatomic, copy) NSString *colorName;

- (id)initWithColorName:(NSString *)colorName;


@end

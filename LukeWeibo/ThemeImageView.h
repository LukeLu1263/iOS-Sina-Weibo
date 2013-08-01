//
//  ThemeImageView.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-5.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property(nonatomic, copy)      NSString *imageName;

@property(nonatomic, assign)    int leftCapWidth;
@property(nonatomic, assign)    int topCapHeight;

- (id)initWithImageName:(NSString *)imageName;

@end

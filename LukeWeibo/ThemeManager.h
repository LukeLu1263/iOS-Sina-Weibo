//
//  ThemeManager.h
//  LukeWeibo
//  主题管理类
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  kThemeDidChangeNotification @"kThemeDidChangeNotification"

@interface ThemeManager : NSObject

// current used theme name.
@property(nonatomic, retain) NSString *themeName;
@property(nonatomic, retain) NSDictionary *themesPlist;
@property(nonatomic, retain) NSDictionary *fontColorPlist;

+ (ThemeManager *)shareInstance;

- (id)init;

- (void)setThemeName:(NSString *)themeName;

// return image name of the current theme
- (UIImage *)getThemeImage:(NSString *)imageName;

- (UIColor *)getColorWithName:(NSString *)name;

@end

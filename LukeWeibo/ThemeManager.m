//
//  ThemeManager.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "ThemeManager.h"

static ThemeManager *singleton = nil;

@implementation ThemeManager

+ (ThemeManager *)shareInstance {
    if (singleton == nil) {
        @synchronized(self){
            singleton = [[ThemeManager alloc] init];
        }
    }
    return singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        //读取主题配置文件
        NSString *themePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.themesPlist = [NSDictionary dictionaryWithContentsOfFile:themePath];
        
        //默认为空
        self.themeName = nil;
    }
    return self;
}

//切换主题时，会调用此方法设置主题名称 (Called by ThemeViewController)
- (void)setThemeName:(NSString *)themeName {
    if (_themeName != themeName) {
        [_themeName release];
        _themeName = [themeName copy];
    }
    
    //切换主题，重新加载当前主题下的字体配置文件
    NSString *themeDir = [self getThemePath];
    NSString *filePath = [themeDir stringByAppendingPathComponent:@"fontColor.plist"];
    self.fontColorPlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
}

//获取主题目录
- (NSString *)getThemePath {
    if (self.themeName == nil) { 
        //如果主题名为空，则使用项目包根目录下的默认主题图片
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        return resourcePath;
    }
    
    //取得主题目录, 如：Skins/blue
    NSString *themePath = [self.themesPlist objectForKey:_themeName];
    //程序包的根目录
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    
    //完整的主题包目录
    NSString *path = [resourcePath stringByAppendingPathComponent:themePath];
    
    return path;
}


//返回当前主题下的图片
- (UIImage *)getThemeImage:(NSString *)imageName {
    if (imageName.length == 0) {
        return nil;
    }
    
    //获取主题目录
    NSString *themePath = [self getThemePath];
    //imageName在当前主题的路径
    NSString *imagePath = [themePath stringByAppendingPathComponent:imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}

- (UIColor *)getColorWithName:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    
    //返回三色值，如：24,35,60
    NSString *rgb = [_fontColorPlist objectForKey:name];
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    if (rgbs.count == 3) {
        float r = [rgbs[0] floatValue];
        float g = [rgbs[1] floatValue];
        float b = [rgbs[2] floatValue];
        UIColor *color = Color(r, g, b, 1);
        return color;
    }
    
    return nil;
}

//限制当前对象创建多实例
#pragma mark - singleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singleton == nil) {
            singleton = [super allocWithZone:zone];
        }
    }
    return singleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}

@end

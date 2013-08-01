//
//  ThemeImageView.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-5.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

// 使用xib创建后， 调用该初始化方法而不调用init方法
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeNotification:)
                                                 name:kThemeDidChangeNotification
                                               object:nil];
}

- (id)initWithImageName:(NSString *)imageName {
    self = [self init];
    if (self) {
        self.imageName = imageName;
    }
    return self; 
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(themeNotification:) 
                                                     name:kThemeDidChangeNotification 
                                                   object:nil];
    }
    return  self;
}

- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        [_imageName release];
        _imageName = [imageName copy];
    }
    [self loadThemeImage];
}

- (void)setLeftCapWidth:(int)leftCapWidth {
    _leftCapWidth = leftCapWidth;
    
    [self loadThemeImage];
}

- (void)setTopCapHeight:(int)topCapHeight {
    _topCapHeight = topCapHeight;
    
    [self loadThemeImage];
}

- (void)loadThemeImage {
    if (self.imageName == nil) {
        return;
    }
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:_imageName];
    image = [image stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapHeight]; //已被新方法替代
    self.image = image;
}

- (void)themeNotification:(NSNotification *)notification {
    [self loadThemeImage];
}

- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_imageName release];
}

@end

//
//  ThemeButton.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (id)initWithImage:(NSString *)imageName highlighted:(NSString *)highlightImageName {
    self = [self init];
    if (self) {
        self.imageName = imageName;
        self.highlightImageName = highlightImageName;
    }
    return self;
}

- (id)initWithBackground:(NSString *)backgroundImageName highlightedBackground:(NSString *)backgroundHighlightImageName {
    self = [self init];
    if (self) {
        self.backgroundImageName = backgroundImageName;
        self.backgroundHighlightImageName = backgroundHighlightImageName;
    }
    return self;
    
}

#pragma mark - setter   设置图片名后，重新加载该图片名对应的图片
- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        [_imageName release];
        _imageName = [imageName copy];
    }
    [self loadThemeImage];
}

- (void)setHighlightImageName:(NSString *)highlightImageName {
    if (_highlightImageName != highlightImageName) {
        [_highlightImageName release];
        _highlightImageName = [highlightImageName copy];
    }
    [self loadThemeImage];
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName {
    if (_backgroundImageName != backgroundImageName) {
        [_backgroundImageName release];
        _backgroundImageName = [backgroundImageName copy];
    }
    [self loadThemeImage];
}

- (void)setBackgroundHighlightImageName:(NSString *)backgroundHighlightImageName {
    if (_backgroundHighlightImageName != backgroundHighlightImageName) {
        [_backgroundHighlightImageName release];
        _backgroundHighlightImageName = [backgroundHighlightImageName copy];
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
    ThemeManager *themeManager = [ThemeManager shareInstance];
    
    UIImage *image =[themeManager getThemeImage:_imageName];
    UIImage *highlightImage = [themeManager getThemeImage:_highlightImageName];
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    highlightImage = [highlightImage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:highlightImage forState:UIControlStateHighlighted];
    
    
    UIImage *backImage = [themeManager getThemeImage:_backgroundImageName];
    UIImage *backHighlightImage = [themeManager getThemeImage:_backgroundHighlightImageName];
    backImage = [backImage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    backHighlightImage = [backHighlightImage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    [self setBackgroundImage:backHighlightImage forState:UIControlStateHighlighted];
}

#pragma mark - Notifacation
- (void)themeNotification:(NSNotification *)notification {
    [self loadThemeImage];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_imageName release];
    [_highlightImageName release];
    [_backgroundImageName release];
    [_backgroundHighlightImageName release];
    [super dealloc];
}

@end

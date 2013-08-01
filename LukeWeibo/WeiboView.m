//
//  WeiboView.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-6.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "WeiboView.h"
#import "UIFactory.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "ThemeImageView.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"
#import "UIUtils.h"
#import "UserViewController.h"
#import "WebViewController.h"

#define LIST_FONT           14.0f   //列表中文本字体
#define LIST_REPOST_FONT    13.0f   //列表中转发的文本字体
#define DETAIL_FONT         18.0f   //详情的文本字体
#define DETAIL_REPOST_FONT  17.0f   //详情中转发的文本字体


@implementation WeiboView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
        _parseText = [[NSMutableString alloc] init];
    }
    return self;
}

// initialize subView
- (void)_initView {
    
    // weibo content
    _textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _textLabel.delegate = self;
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    //   十进制RGB:  r:69 g:149 b:203
    //  十六进制RGB: 4595CB
    _textLabel.linkAttributes         = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self addSubview:_textLabel];
    
    // weibo image
    _image = [[UIImageView alloc] initWithFrame:CGRectZero];
    _image.image = [UIImage imageNamed:@"page_image_loading.png"];
    [self addSubview:_image];
    
    // the background of repost weiboView
    _repostBackgroundView = [UIFactory createImageView:@"timeline_retweet_background.png"];
    UIImage *image = [_repostBackgroundView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    _repostBackgroundView.image = image;
    _repostBackgroundView.leftCapWidth = 25;
    _repostBackgroundView.topCapHeight = 10;
    _repostBackgroundView.backgroundColor = [UIColor clearColor];
    [self insertSubview:_repostBackgroundView atIndex:0];
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
    }
    
    // create repost weibo view
    if (_repostView == nil) {
        _repostView = [[WeiboView alloc] initWithFrame:CGRectZero];
        _repostView.isRepost = YES;
        _repostView.isDetail = self.isDetail;
        [self addSubview:_repostView];
    }
    
    [self parseLink];
}

// 解析超链接
- (void)parseLink {
    [_parseText  setString:@""];
    
    // 判断当前是否为转发微博
    if (_isRepost) {
        //将原微博作者拼接
        //原微博作者昵称
        NSString *nickName = _weiboModel.user.screen_name;
        [_parseText appendFormat:@"<a href='user://%@'>%@</a>:", [nickName URLEncodedString] , nickName];
    }
    
    NSString *text = _weiboModel.text;
    text = [UIUtils parseLink:text];
    [_parseText appendString:text];
    
}

// layoutSubViews 展示数据、子视图布局
// layoutSubViews 方法有可能被调用多次
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //------------------------微博内容_textLabel子视图-----------------------//
    [self _renderLabel];
    
    //-----------------------转发的微博视图 _repostView-----------------//
    [self _renderSourceWeiboView];
    
    //-----------------------微博图片视图 _image--------------------------//
    [self _renderImage];
    
    //-----------------------转发的微博视图背景----------------------------//
    if (self.isRepost) {
        _repostBackgroundView.frame = self.bounds;
        _repostBackgroundView.hidden = NO;
    } else {
        _repostBackgroundView.hidden = YES;
    }
    
}

- (void)_renderLabel {
    // 获取字体大小
    CGFloat fontSize = [WeiboView getFontSize:self.isDetail isRepost:self.isRepost];
    _textLabel.font = [UIFont systemFontOfSize:fontSize];
    _textLabel.frame = CGRectMake(0, 0, self.width, 20);
    
    // 判断当前视图是否为转发视图
    if (self.isRepost) {
        _textLabel.frame = CGRectMake(10, 10, self.width-20, 0);
    }
    _textLabel.text =  _parseText;
    
    //文本内容尺寸
    CGSize textSize = _textLabel.optimumSize;
    _textLabel.height = textSize.height;
}

- (void)_renderSourceWeiboView {
    // 转发的微博model
    WeiboModel *repostWeibo = _weiboModel.relWeibo;
    if (repostWeibo != nil) {
        _repostView.hidden = NO;
        _repostView.weiboModel = repostWeibo;
        float height = [WeiboView getWeiboViewHeight:repostWeibo isRepost:YES isDetail:self.isDetail];
        _repostView.frame = CGRectMake(0, _textLabel.bottom, self.width, height);
    } else {
        _repostView.hidden = YES;
    }
}

- (void)_renderImage {
    if (self.isDetail) {
        // 中等图
        NSString *bmiddleImage = _weiboModel.bmiddleImage;
        if (bmiddleImage && ![@"" isEqualToString:bmiddleImage]) {
            _image.hidden = NO;
            _image.frame = CGRectMake(10, _textLabel.bottom+10, 280, 200);
            
            // 加载网络图片数据
            [_image setImageWithURL:[NSURL URLWithString:bmiddleImage]];
            
        }
        else {
            _image.hidden = YES;
        }
    }
    else {
        //图片浏览模式
        int mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        if (mode == 0) {
            mode = SmallBrowMode;
        }
        //小图浏览模式
        if (mode == SmallBrowMode) {
            // 缩略图
            NSString *thumbnailImage = _weiboModel.thumbnailImage;
            if (thumbnailImage && ![@"" isEqualToString:thumbnailImage]) {
                _image.hidden = NO;
                _image.frame = CGRectMake(10, _textLabel.bottom+10, 70, 80);
                
                // 加载网络图片数据
                [_image setImageWithURL:[NSURL URLWithString:thumbnailImage]];
            }
            else {
                _image.hidden = YES;
            }
        
    }
    //大图浏览模式
    else if (mode == LargeBrowMode) {
        NSString *bmiddleImage = _weiboModel.bmiddleImage;
        if (bmiddleImage && ![@"" isEqualToString:bmiddleImage]) {
            _image.hidden = NO;
            _image.frame = CGRectMake(10, _textLabel.bottom+10, self.width-20, 180);
            
            // 加载网络图片数据
            [_image setImageWithURL:[NSURL URLWithString:bmiddleImage]];
        }
        else {
            _image.hidden = YES;
        }
    }
    
}
}

#pragma mark - 计算(类方法)
// 获取字体大小
+ (CGFloat)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost {
    float fontSize = 14.0f;
    
    if (!isDetail && !isRepost) {
        return LIST_FONT;
    } else if (!isDetail && isRepost) {
        return LIST_REPOST_FONT;
    } else if (isDetail && !isRepost) {
        return DETAIL_FONT;
    } else if (isDetail && isRepost) {
        return DETAIL_REPOST_FONT;
    }
    return fontSize;
}

+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                     isRepost:(BOOL)isRepost
                     isDetail:(BOOL)isDetail {
    /**
     *  实现思路: 计算每个子视图的高度，然后相加.
     **/
    float height = 0;
    
    //----------------------计算微博内容text的高度------------------------//
    RTLabel *textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    CGFloat fontSize = [WeiboView getFontSize:isDetail isRepost:isRepost];
    textLabel.font = [UIFont systemFontOfSize:fontSize];
    // 判断此微博是否显示在详情页面
    if (isDetail) {
        textLabel.width = kWeibo_Width_Detail;
    }
    else {
        textLabel.width = kWeibo_Width_List;
    }
    
    NSString *weiboText = nil;
    if (isRepost) {
        textLabel.width -= 20;
        NSString *nickName = weiboModel.user.screen_name;
        
        weiboText = [NSString stringWithFormat:@"%@:%@", nickName, weiboModel.text];
    }
    else {
        weiboText = weiboModel.text;
    }
    textLabel.text = weiboText;
    
    height += textLabel.optimumSize.height;
    [textLabel release];
    
    //----------------------计算微博图片的高度-----------------------------//
    if (isDetail) {
        NSString *bmiddleImage = weiboModel.bmiddleImage;
        if (bmiddleImage && ![@"" isEqualToString:bmiddleImage]) {
            height += (200+10);
        }
    }
    else {
        //图片浏览模式
        int mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        if (mode == 0) {
            mode = SmallBrowMode;
        }
        //小图浏览模式
        if (mode == SmallBrowMode) {
            NSString *thumbnailImage = weiboModel.thumbnailImage;
            if (thumbnailImage && ![@"" isEqualToString:thumbnailImage]) {
                height += (80+10);
            }
        }
        else {
            NSString *bmiddleImage = weiboModel.bmiddleImage;
            if (bmiddleImage && ![@"" isEqualToString:bmiddleImage]) {
                height += (180+10);
            }
        }
    }
    
    //----------------------计算转发微博视图的高度-----------------------------//
    //转发的微博
    WeiboModel *relWeibo = weiboModel.relWeibo;
    if (relWeibo) {
        CGFloat repostHeight = [WeiboView getWeiboViewHeight:relWeibo isRepost:YES isDetail:isDetail];
        height += repostHeight;
    }
    
    if (isRepost == YES) {
        height += 30;
    }
    return height;
}

#pragma mark - RTLabel delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    NSString *urlstring = [[url absoluteString] URLDecodedString]; 
    
    if ([urlstring hasPrefix:@"user"]) {
        urlstring = [url host];

        UserViewController *userCtrl = [[UserViewController alloc] init];
        userCtrl.userName = self.weiboModel.user.screen_name;
        [self.viewController.navigationController pushViewController:userCtrl animated:YES];
        [userCtrl release];
        
    }
    else if ([urlstring hasPrefix:@"http"]) {
        
        WebViewController *webView = [[WebViewController alloc] initWithUrl:urlstring];
        [self.viewController.navigationController pushViewController:webView animated:YES];
        [webView release];
        
    }
    else if ([urlstring hasPrefix:@"topic"]) {
        urlstring = [url host];
        NSLog(@"话题: %@", urlstring);
    }
}

- (void)dealloc
{
    [_textLabel release];
    [_image release];
    [_repostBackgroundView release];
    [_repostView release];
    [_parseText release];
    [_weiboModel release];
    [super dealloc];
}

@end

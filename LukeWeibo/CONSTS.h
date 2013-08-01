//
//  CONSTS.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#ifndef LukeWeibo_CONSTS_h
#define LukeWeibo_CONSTS_h


#define kAppKey @"2640617897"
#define kAppSecret @"2f1cb6cabab2f648d89c625167de95e6"
#define kAppRedirectURI @"https://api.weibo.com/oauth2/default.html"


// URL
#define URL_POIS            @"place/nearby/pois.json"
#define URL_HOME_TIMELINE   @""
#define URL_COMMENTS        @""
#define URL_UPDATE          @""
#define URL_UPLOAD          @""
#define URL_USER_SHOW       @""
#define URL_TIMELINE        @""
#define URL_FOLLOWERS       @"friendships/followers.json"   //粉丝列表
#define URL_FRIENDS         @"friendships/friends.json"     //关注列表


//每次请求的微博数
#define RequestCount @"20"


// color
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// font color key
#define kNavigationBarTitleLabel    @"kNavigationBarTitleLabel"
#define kThemeListLabel             @"kThemeListLabel"


//-----------------通知---------------------
#define kReloadWeiboTableNotification @"kReloadWeiboTableNotification"

//UserDefault keys
#define kThemeName      @"kThemeName"

#define kBrowMode       @"kBrowMode"
#define LargeBrowMode   1   // 大图浏览模式
#define SmallBrowMode   2   // 小图浏览模式

#endif
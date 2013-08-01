//
//  BaseViewController.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@class MBProgressHUD;
@class AppDelegate;
@interface BaseViewController : UIViewController
{
    UIView *_loadView;
    UIWindow *_tipWindow;
}

@property(nonatomic, assign) BOOL isBackButton;
@property(nonatomic, assign) BOOL isCancelButton;
@property(nonatomic, retain) MBProgressHUD *hud;

- (SinaWeibo *)sinaweibo;
- (AppDelegate *)appDelegate;

// 加载提示
- (void)showLoading:(BOOL)show;
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim;
- (void)showHUDComplete:(NSString *)title;
- (void)hideHUD;

// 状态栏上的提示
- (void)showStatusTip:(BOOL)show title:(NSString *)title;

@end

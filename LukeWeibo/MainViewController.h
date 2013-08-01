//
//  MainViewController.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@class HomeViewController;
@interface MainViewController : UITabBarController <SinaWeiboDelegate, UINavigationControllerDelegate>{
    UIView *_tabBarView;
    UIImageView *_sliderView;
    UIImageView *_badgeView;
    HomeViewController *_homeCtrl;
}

- (void)showBadge:(BOOL)show;
- (void)showTabBar:(BOOL)show;

@end

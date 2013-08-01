//
//  MainViewController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "UserViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "UIFactory.h"
#import "ThemeButton.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBar setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self _initViewController];
    [self _initTabBarView];
    
    // 每30秒请求一次未读数接口
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

- (void)showBadge:(BOOL)show {
    _badgeView.hidden = !show;
}

- (void)showTabBar:(BOOL)show {
    [UIView animateWithDuration:0.35 animations:^{
        if (show) {
            _tabBarView.left = 0;
        } else {
            _tabBarView.left = -ScreenWidth;
        }
    }];
    
    [self _resizeView:show];
}

#pragma mark - UI
- (void)_resizeView:(BOOL)showTabBar {
    for (UIView *subView in self.view.subviews) {
        //NSLog(@"%@", subView);
        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            if (showTabBar) {
                subView.height = ScreenHeight - 49 -20;
            } else {
                subView.height = ScreenHeight - 20;
            }
        }
    }
}

- (void)_initViewController
{
                   _homeCtrl            = [[HomeViewController alloc] init];
    MessageViewController *message      = [[[MessageViewController alloc] init] autorelease];
//    ProfileViewController *profile      = [[[ProfileViewController alloc] init] autorelease];
    UserViewController *profile = [[UserViewController alloc] init];// autorelease];
    DiscoverViewController *discover    = [[[DiscoverViewController alloc] init] autorelease];
    MoreViewController *more            = [[[MoreViewController alloc] init] autorelease];

    profile.showLoginUser = YES; // 是否是登陆用户的“个人资料页”
    
    NSArray *views = @[_homeCtrl, message, profile, discover, more];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController * viewController in views) {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
        [nav release];
        
        nav.delegate = self;
    }

    self.viewControllers = viewControllers;
}

//创建custom tabBar
- (void)_initTabBarView {
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49-20, ScreenWidth, 49)];
//    _tabBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    [self.view addSubview:_tabBarView];

    UIImageView *tabBarGroundImage = [UIFactory createImageView:@"tabbar_background.png"];
    tabBarGroundImage.frame = _tabBarView.bounds;
    [_tabBarView addSubview:tabBarGroundImage];
    
    NSArray *background = @[@"tabbar_home.png",
                            @"tabbar_message_center.png",
                            @"tabbar_profile.png",
                            @"tabbar_discover.png",
                            @"tabbar_more.png"];

    NSArray *heightBackground = @[@"tabbar_home_highlighted.png",
                                  @"tabbar_message_center_highlighted.png",
                                  @"tabbar_profile_highlighted.png",
                                  @"tabbar_discover_highlighted.png",
                                  @"tabbar_more_highlighted.png"];
    
    for (int i = 0; i < background.count; ++i) {
        NSString *backImage     = background[i];
        NSString *heightImage   = heightBackground[i];
        
        UIButton *button = [UIFactory createButton:backImage highlighted:heightImage];
        button.showsTouchWhenHighlighted = YES;
        int buttonWidth = ScreenWidth/5;
        button.frame = CGRectMake((buttonWidth-30)/2+i*buttonWidth, (49-30)/2, 30, 30);
        button.tag = i;
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarView addSubview:button];
    }
    
    _sliderView = [[UIFactory createImageView:@"tabbar_slider.png"] retain];
    _sliderView.backgroundColor = [UIColor clearColor];
    _sliderView.frame = CGRectMake((ScreenWidth/5-15)/2, 0, 15, 44);
    [_tabBarView addSubview:_sliderView];
    
}

- (void)refreshUnReadViews:(NSDictionary *)result {
    // 新微博未读数
    NSNumber *status = [result objectForKey:@"status"];
    
    if (_badgeView == nil) {
        _badgeView = [UIFactory createImageView:@"main_badge.png"];
        _badgeView.frame = CGRectMake(64-25, 5, 20, 20);
        [_tabBarView addSubview:_badgeView];
        
        UILabel *badgeLabel = [[UILabel alloc] initWithFrame:_badgeView.bounds];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        badgeLabel.textColor = [UIColor purpleColor];
        badgeLabel.tag = 100;
        [_badgeView addSubview:badgeLabel];
        [badgeLabel release];
    }
    
    int n = [status intValue];
    if (n > 0) {
        UILabel *badgeLabel = (UILabel *)[_badgeView viewWithTag:100];
        if (n > 99) {
            n = 99;
        }
        badgeLabel.text = [NSString stringWithFormat:@"%d", n];
        _badgeView.hidden = NO;
    } else {
        _badgeView.hidden = YES;
    }

}

#pragma mark - data

- (void)loadUnreadData {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    [sinaweibo requestWithURL: @"remind/unread_count.json"
                       params:nil
                   httpMethod:@"GET"
                        block:^(NSDictionary *result) {
                            [self refreshUnReadViews:result];
                        }];
}

#pragma mark - actions
// tab 按钮的点击事情
- (void)selectedTab:(UIButton *)button {

    float x = button.left + (button.width - _sliderView.width)/2;
    [UIView animateWithDuration:0.2 animations:^{
        _sliderView.left = x;
    }];
    
    // 判断是否是重复点击tabBar按钮
    if (button.tag == self.selectedIndex && button.tag == 0) {
//        UINavigationController *homeNav = [self.viewControllers objectAtIndex:0];
//        HomeViewController *homeCtrl = [homeNav.viewControllers objectAtIndex:0];
        [_homeCtrl refreshWeibo];
    }

    self.selectedIndex = button.tag;
    
}

- (void)timerAction:(NSTimer *)timer {
    [self loadUnreadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SinaWeibo delegate
// 登陆成功协议方法
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    // save authentication data.
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_homeCtrl loadWeiboData];
}

// 注销成功后调用方法
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
    // remove login data
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo {
    NSLog(@"sinaweiboLogInDidCancel");
}

#pragma mark - UINavigationController delegate
// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    // 导航控制器子控制器的个数
    int count = navigationController.viewControllers.count;
    if (count == 2) {
        [self showTabBar:NO];
    } else if (count == 1) {
        [self showTabBar:YES];
    }

}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
}

- (void)dealloc
{
    [_tabBarView release];
    [_sliderView release];
    [_badgeView release];
    [_homeCtrl release];
    [super dealloc];
}

@end

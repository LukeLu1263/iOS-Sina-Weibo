//
//  BaseViewController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "UIFactory.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton = YES;
        self.isCancelButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && self.isBackButton) {
        UIButton *button = [UIFactory createButton:@"navigationbar_back.png"
                                       highlighted:@"navigationbar_back_highlighted.png"];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(0, 0, 24, 24);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = [backItem autorelease];
    }
    
    if (self.isCancelButton) {
        UIButton *cancelButton = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) //被拉宽了
                                                             title:@"取消"
                                                            target:self
                                                            action:@selector(cancelAction)];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        self.navigationItem.leftBarButtonItem = [cancelItem autorelease];
        
    }
}

#pragma  mark - actions
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelAction {

    [self dismissViewControllerAnimated:YES completion:NULL]; // 仅支持5.0以后
    
//    [self dismissModalViewControllerAnimated:YES]; // 2.0~6.0
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//override
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //    titleLabel.textColor = [UIColor blackColor];
    
    UILabel *titleLabel = [UIFactory createLabel:kNavigationBarTitleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (AppDelegate *)appDelegate {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

- (SinaWeibo *)sinaweibo {
    return self.appDelegate.sinaweibo;
}

#pragma mark - loading prompt
- (void)showLoading:(BOOL)show {
    if (_loadView == nil) {
        _loadView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2-80, ScreenWidth, 20)];
        
        // loading view
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [activityView startAnimating];
        // 正在加载的Label
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text = @"Loading...";
        loadLabel.font = [UIFont boldSystemFontOfSize:16.0];
        loadLabel.textColor = [UIColor blackColor];
        [loadLabel sizeToFit];
        
        loadLabel.left = (ScreenWidth - loadLabel.width)/2;
        activityView.right = loadLabel.left - 5;
        
        [_loadView addSubview:loadLabel];
        [_loadView addSubview:activityView];
        [activityView release];
    }
    if (show && ![_loadView superview]) {
        [self.view addSubview:_loadView];
    } else {
        [_loadView removeFromSuperview];
    }
}

- (void)showHUD:(NSString *)title isDim:(BOOL)isDim {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
}

- (void)showHUDComplete:(NSString *)title {
    self.hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }
    [self.hud hide:YES afterDelay:1];
}

- (void)hideHUD {
    [self.hud hide:YES];
}

- (void)showStatusTip:(BOOL)show title:(NSString *)title {
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:13.0f];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.tag = 2013;
        [_tipWindow addSubview:tipLabel];

        UIImageView *progress = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]];
        progress.frame = CGRectMake(0, 20-6, 100, 6);
        progress.tag = 2012;
        [_tipWindow addSubview:progress];
    }
    
    UILabel *tipLabel = (UILabel *)[_tipWindow viewWithTag:2013];
    UIImageView *progress = (UIImageView *)[_tipWindow viewWithTag:2012];
    if (show) {
        tipLabel.text = title;
        _tipWindow.hidden = NO;
        // 不能使用下面的方式，它会影事件响应。
        // [_tipWindow makeKeyAndVisible];
        progress.left = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2];
        // 匀速移动
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationRepeatCount:1000];
        progress.left = ScreenWidth;
        [UIView commitAnimations];
        
    } else {
        progress.hidden = YES;
        tipLabel.text = title;
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1.5];
    }
}

- (void)removeTipWindow {
    _tipWindow.hidden = YES;
    // 如果不是在dealloc里release的，就需要设为nil，安全释放.
    [_tipWindow release];
    _tipWindow = nil;
}

- (void)dealloc
{
    [_loadView release];
    [super dealloc];
}

@end

//
//  DiscoverViewController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearWeiboMapViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"广场";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i=100; i<=101; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        // 阴影的偏移量(大小)
        button.layer.shadowOffset = CGSizeMake(2, 2);
        // 阴影的透明度
        button.layer.shadowOpacity = 1;
//        button.layer.shadowRadius = 13;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nearWeiboButton release];
    [_nearUserButton release];
    [super dealloc];
}
- (IBAction)nearWeiboAction:(id)sender {
    NearWeiboMapViewController *near = [[NearWeiboMapViewController alloc] init];
    [self.navigationController pushViewController:near animated:YES];
    [near release];
}

- (IBAction)nearUserAction:(id)sender {
}
@end

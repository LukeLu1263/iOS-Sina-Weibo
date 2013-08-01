//
//  BrowModeController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-11.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BrowModeController.h"
#import "CONSTS.h"

@interface BrowModeController ()

@end

@implementation BrowModeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:nil] autorelease];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"大图";
        cell.detailTextLabel.text = @"所有网络加载大图";
    } else if(indexPath.row == 1) {
        cell.textLabel.text = @"小图";
        cell.detailTextLabel.text = @"所有网络加载小图";
    }
    else if(indexPath.row == 2) {
        cell.textLabel.text = @"默认";
        cell.detailTextLabel.text = @"WiFi下加载大图,蜂窝数据模式下加载小图.";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int mode = -1;
    if (indexPath.row == 0) {
        mode = LargeBrowMode;
    }
    else if (indexPath.row == 1) {
        mode = SmallBrowMode;
    }
    else if (indexPath.row == 2) {
        mode = SmallBrowMode;
    }
    
    // 将浏览模式存到本地
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrowMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //发送刷新微博列表的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end

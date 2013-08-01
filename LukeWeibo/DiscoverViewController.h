//
//  DiscoverViewController.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-4.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"

@interface DiscoverViewController : BaseViewController
@property (retain, nonatomic) IBOutlet UIButton *nearWeiboButton;
@property (retain, nonatomic) IBOutlet UIButton *nearUserButton;

- (IBAction)nearWeiboAction:(id)sender;
- (IBAction)nearUserAction:(id)sender;
@end

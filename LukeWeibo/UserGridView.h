//
//  UserGridView.h
//  LukeWeibo

//  一个user对象

//  Created by Luke Lu on 13-4-16.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserGridView : UIView

@property (nonatomic, retain) UserModel *userModel;

@property (retain, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *fansLabel;
@property (retain, nonatomic) IBOutlet UIButton *imageButton;

- (IBAction)userImageAction:(UIButton *)sender;
@end

//
//  UserInfoView.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-11.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RectButton;
@class UserModel;
@interface UserInfoView : UIView

@property (nonatomic, retain)UserModel *user;

@property (retain, nonatomic) IBOutlet UIImageView *userImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
@property (retain, nonatomic) IBOutlet UILabel *countLabel;
@property (retain, nonatomic) IBOutlet RectButton *atButton;
@property (retain, nonatomic) IBOutlet RectButton *fansButton;


- (IBAction)AtAction:(id)sender;

- (IBAction)fansAction:(id)sender;
@end

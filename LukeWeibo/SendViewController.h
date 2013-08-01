//
//  SendViewController.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-12.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"

@interface SendViewController : BaseViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NSMutableArray *_buttons;
    UIImageView *_fullImageView; // 全屏显示将要上传图片
}

// send data
// 经度
@property (nonatomic, copy) NSString *longtitude;
// 纬度
@property (nonatomic, copy) NSString *latitude;
// 发送的图片
@property (nonatomic, copy) UIImage *sendImage;
// 图片缩略图
@property (nonatomic, retain) UIButton *sendImageButton;

// 编辑输入框
@property (retain, nonatomic) IBOutlet UITextView *textView;
// 工具栏
@property (retain, nonatomic) IBOutlet UIView *editorBar;
// 地理位置视图
@property (retain, nonatomic) IBOutlet UIView *placeView;
// 显示位置的文本
@property (retain, nonatomic) IBOutlet UILabel *placeLabel;

@property (retain, nonatomic) IBOutlet UIImageView *placeBackgroundView;
 
@end

//
//  SendViewController.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-12.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "SendViewController.h"
#import "UIFactory.h"
#import "NearbyViewController.h"
#import "BaseNavigationController.h"
#import "DataService.h"
//#import "NSString+URLEncoding.h"


@interface SendViewController ()

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发布新微博";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        
        // 放在[super viewDidLoad]之前
        self.isBackButton = NO;
        self.isCancelButton = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _buttons = [[NSMutableArray alloc] initWithCapacity:6];
    
    UIButton *sendButton = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) //被拉宽了
                                                       title:@"发送"
                                                      target:self
                                                      action:@selector(sendAction)];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = [sendItem autorelease];
    
    [self _initViews];
}

- (void)_initViews {
    
    // 显示键盘
    [self.textView becomeFirstResponder];
    NSArray *imageNames = [NSArray arrayWithObjects:
                           @"compose_locatebutton_background.png",
                           @"compose_camerabutton_background.png",
                           @"compose_trendbutton_background.png",
                           @"compose_mentionbutton_background.png",
                           @"compose_emoticonbutton_background.png",
                           @"compose_keyboardbutton_background.png",
                           nil];
    
    NSArray *imageHighted = [NSArray arrayWithObjects:
                             @"compose_locatebutton_background_highlighted.png",
                             @"compose_camerabutton_background_highlighted.png",
                             @"compose_trendbutton_background_highlighted.png",
                             @"compose_mentionbutton_background_highlighted.png",
                             @"compose_emoticonbutton_background_highlighted.png",
                             @"compose_keyboardbutton_background_highlighted.png",
                             nil];
    for (int i = 0; i < imageNames.count; i++) {
        NSString *imageName = [imageNames objectAtIndex:i];
        NSString *hightedName = [imageHighted objectAtIndex:i];
        UIButton *button = [UIFactory createButton:imageName highlighted:hightedName];
        [button setImage:[UIImage imageNamed:hightedName] forState:UIControlStateSelected];
        button.tag = (10+i);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(20+(ScreenWidth/5*i), 25, 23, 19);
        [self.editorBar addSubview:button];
        [_buttons addObject:button];
        
        if (i == 5) {
            button.hidden = YES;
            button.left -= ScreenWidth/5;
        }
    }
    
    UIImage *image = [self.placeBackgroundView.image stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    self.placeBackgroundView.image = image;
    self.placeBackgroundView.width = 200;
    
    self.placeLabel.left = 45;
    self.placeLabel.width = 160;
    
}

#pragma mark - data
- (void)doSendData {
    [super showStatusTip:YES title:@"发送中..."];
    
    NSString *text = self.textView.text;
    
    if (text.length == 0) {
        NSLog(@"微博内容为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    
    if (self.longtitude.length > 0) {
        [params setObject:self.longtitude forKey:@"lon"];
    }
    if (self.latitude.length > 0) {
        [params setObject:self.latitude forKey:@"lat"];
    }
    
    if (self.sendImage == nil) {
        // 不带图
        [self.sinaweibo requestWithURL:@"statuses/update.json"
                                params:params
                            httpMethod:@"POST"
                                 block:^(id result){
                                     
                                     NSLog(@"%@", result);
                                     [super showStatusTip:NO title:@"发送成功!"];
                                     [self dismissViewControllerAnimated:YES completion:NULL];
                                 }];
    } else {
        // 带图
        NSData *data = UIImageJPEGRepresentation(self.sendImage, 0.3); // 0.3为图片压缩比例
        [params setObject:data forKey:@"pic"];
        
//        [self.sinaweibo requestWithURL:@"statuses/upload.json"
//                                params:params
//                            httpMethod:@"POST"
//                                 block:^(id result){
//                                     
//                                     NSLog(@"%@", result);
//                                     [super showStatusTip:NO title:@"发送成功!"];
//                                     [self dismissViewControllerAnimated:YES completion:NULL];
//                                 }];

        // 使用自己封装的network request
        [DataService requestWithURL:@"statuses/upload.json"
                             params:params httpMethod:@"POST"
                      completeBlock:^(id result) {
                          
            [super showStatusTip:NO title:@"发送成功!"];
            [self dismissViewControllerAnimated:YES completion:NULL];
                          
        }];
    }
}

// 定位使用位置
- (void)location {
    // 有导航栏，需要添加到导航控制器上
    NearbyViewController *nearby = [[NearbyViewController alloc] init];
    BaseNavigationController *nearbyNav = [[BaseNavigationController alloc] initWithRootViewController:nearby];
    [self presentViewController:nearbyNav animated:YES completion:nil];
    [nearby release];
    [nearbyNav release];
    
    nearby.selectDoneBlock = ^(NSDictionary *result) {
        
        // 记录位置坐标
        self.longtitude = [result objectForKey:@"lon"];
        self.latitude = [result objectForKey:@"lat"];
        
        NSString *address = [result objectForKey:@"address"];
        if ([address isKindOfClass:[NSNull class]] || address.length == 0) {
            address = [result objectForKey:@"title"];
        }
        
        self.placeView.hidden = NO;
        self.placeLabel.text = address;
        
        UIButton *locationButton = [_buttons objectAtIndex:0];
        locationButton.selected = YES;
    };
    
}

// 使用相片
- (void)selectImage {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"拍照"
                                                    otherButtonTitles:@"用户相册", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark - actions
- (void)sendAction {
    [self doSendData];
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 10) {
        [self location];
    }
    else if (button.tag == 11) {
        [self selectImage];
    }
    else if (button.tag == 12) {
        
    }
    else if (button.tag == 13) {
        
    }
    else if (button.tag == 14) {
        
    }
}

- (void)imageAction:(UIButton *)button {
    if (_fullImageView == nil) {
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _fullImageView.backgroundColor = [UIColor blackColor];
        _fullImageView.userInteractionEnabled = YES;
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageAction:)];
        [_fullImageView addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        // 创建删除按钮
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
        deleteButton.frame = CGRectMake(280, 40, 20, 26);
        deleteButton.tag = 100;
        deleteButton.hidden = YES;
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [_fullImageView addSubview:deleteButton];
    }

    [self.textView resignFirstResponder];
    if (![_fullImageView superview]) {
        _fullImageView.image = self.sendImage;
        [self.view.window addSubview:_fullImageView];

        _fullImageView.frame = CGRectMake(5, ScreenHeight-255, 20, 20);
        [UIView animateWithDuration:0.4 animations:^{
            _fullImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarHidden = YES;
            // 显示删除按钮
            [_fullImageView viewWithTag:100].hidden = NO;
        }];
    }
}

// 缩小图片
- (void)scaleImageAction:(UITapGestureRecognizer *)tap {
    // 隐藏删除按钮
    [_fullImageView viewWithTag:100].hidden = YES;
    
    [UIView animateWithDuration:0.4 animations:^{
        _fullImageView.frame = CGRectMake(5, ScreenHeight-255, 20, 20);
    } completion:^(BOOL finished) {
        [_fullImageView removeFromSuperview];
    }];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.textView becomeFirstResponder];
}

// 取消图片
- (void)deleteAction:(UIButton *)deleteButton {
    // 缩小图片
    [self scaleImageAction:nil];
    // 移除缩略图
    [self.sendImageButton removeFromSuperview];
    self.sendImage = nil;
 
    UIButton *button1 = [_buttons objectAtIndex:0];
    UIButton *button2 = [_buttons objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        button1.transform = CGAffineTransformIdentity;
        button2.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - UiActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex == 0) {
        // 拍照
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1) {
        // 用户相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 2) {
        // 取消
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //    NSLog(@"%@", info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.sendImage = image;
    
    if (self.sendImageButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.frame = CGRectMake(5, 20, 25, 25);
        [button addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        self.sendImageButton = button;
    }
    // 设置图片缩略图
    [self.sendImageButton setImage:image forState:UIControlStateNormal];
    [self.editorBar addSubview:self.sendImageButton];
    UIButton *button1 = [_buttons objectAtIndex:0];
    UIButton *button2 = [_buttons objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        button1.transform = CGAffineTransformTranslate(button1.transform, 20, 0);
        button2.transform = CGAffineTransformTranslate(button2.transform, 5, 0);
        // 恢复坐标位置
        //button2.transform = CGAffineTransformIdentity;
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSNotification
- (void)keyboardShowNotification:(NSNotification *)notification {
    //    NSLog(@"%@", notification.userInfo);
    NSValue *keyboardValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [keyboardValue CGRectValue];
    float height = frame.size.height;
    
    self.editorBar.bottom = ScreenHeight-height-20-44;
    self.textView.height = self.editorBar.top;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [_textView release];
    [_editorBar release];
    [_placeView release];
    [_placeBackgroundView release];
    [_placeLabel release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [self setEditorBar:nil];
    [self setPlaceView:nil];
    [self setPlaceBackgroundView:nil];
    [self setPlaceLabel:nil];
    [super viewDidUnload];
}

@end

//
//  WebViewController.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-12.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate> {
    NSString *_url;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithUrl:(NSString *)url;

- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)reload:(id)sender;

@end

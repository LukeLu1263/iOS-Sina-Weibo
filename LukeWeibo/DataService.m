//
//  DataService.m
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-15.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import "DataService.h"
#import "JSONKit.h"

#define BASE_URL @"https://open.weibo.cn/2/"

@implementation DataService

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlString
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                     completeBlock:(RequestFinishBlock)block {
    
    // 取得认证信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
    
    // 拼接URL
    // 例如:url:https://open.weibo.cn/2/statuses/home_timeline.json?count=20&access_token=2.00ujbZWDP2lhsCe25b4efae5MJYJgD
    urlString = [BASE_URL stringByAppendingFormat:@"%@?access_token=%@", urlString, accessToken];
    
    
    // 处理GET请求
    NSComparisonResult compareRet1 = [httpMethod caseInsensitiveCompare:@"GET"];
    if (compareRet1 == NSOrderedSame) {
        NSMutableString *paramsString = [NSMutableString string];
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i<params.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            [paramsString appendFormat:@"%@=%@", key, value];
            
            if (i < params.count-1) {
                [paramsString appendString:@"&"];
            }
        }
        
        if (paramsString.length > 0) {
           urlString = [urlString stringByAppendingFormat:@"&%@", paramsString];
        }
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    // 避免循环引用
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    // 设置请求超时时间
    [request setTimeOutSeconds:60];
    [request setRequestMethod:httpMethod];

    // 处理POST请求方式
    NSComparisonResult compareRet2 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (compareRet2 == NSOrderedSame) {
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i<params.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            // 判断是否文件上传
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value forKey:key];
                // or [request addFile:(NSString *) forKey:(NSString *)];
            } else {
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    // 设置请求完成的block
    [request setCompletionBlock:^{
        NSData *data = request.responseData;
        float version = WXHLOSVersion();
        id result;
        if (version >= 5.0) {
           result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        } else {
           result = [data objectFromJSONData];
        }
        
        if (block) {
            block(result);
        }
    }];
    
    [request startAsynchronous];
    
    return request;
}

@end

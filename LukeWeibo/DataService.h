//
//  DataService.h
//  LukeWeibo
//
//  Created by Luke Lu on 13-4-15.
//  Copyright (c) 2013年 www.lukelu.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestFinishBlock) (id result);

@interface DataService : NSObject

+ (ASIHTTPRequest *)requestWithURL:(NSString *)url
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                     completeBlock:(RequestFinishBlock)block;

@end

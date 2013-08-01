//
//  BaseModel.h
//  MicroBlogClien
//
//  The class's function:
//  1.set setters and deliver parameters to setters for subclass.
//  2.archive in files or transmit between processes.
//
//  Created by Luke Lu on 13-3-8.
//  Copyright (c) 2013年 Luke Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding>{
    
}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串

@end

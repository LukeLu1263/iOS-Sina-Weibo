//
//  BaseModel.m
//  MicroBlogClien
//
//  The class's function:
//  1.set setters and deliver parameters to setters for subclass.
//  2.archive in files or transmit between processes.
//
//  Created by Luke Lu on 13-3-8.
//  Copyright (c) 2013年 Luke Lu. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

/**
 * Initialize Base Model with Dictionary
 */
- (id)initWithDataDic:(NSDictionary *)data {
	if (self = [super init]) {
		[self setAttributes:data];
	}
	return self;
}

/**
 *  Attribute Map Dictionary
 */
- (NSDictionary *)attributeMapDictionary {
	return nil;
}

/**
 *  Get Setter selector with Attribute name.
 */
-(SEL)getSetterSelectorWithAttributeName:(NSString*)attributeName{
	NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
	NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
	return NSSelectorFromString(setterSelStr);
}

/**
 *  Custom description
 */
- (NSString *)customDescription {
	return nil;
}

/**
 *  Decription for dictionary.
 */
- (NSString *)description {
	NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
	NSDictionary *attrMapDic = [self attributeMapDictionary];
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	
	while ((attributeName = [keyEnum nextObject])) {
		SEL getSel = NSSelectorFromString(attributeName);
		if ([self respondsToSelector:getSel]) {
			NSMethodSignature *signature = nil;
			signature = [self methodSignatureForSelector:getSel];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:self];
			[invocation setSelector:getSel];
			NSObject *valueObj = nil;
			[invocation invoke];
			[invocation getReturnValue:&valueObj];
            //            ITTDINFO(@"attributeName %@ value %@", attributeName, valueObj);
			if (valueObj) {
				[attrsDesc appendFormat:@" [%@=%@] ",attributeName, valueObj];
				//[valueObj release];
			}else {
				[attrsDesc appendFormat:@" [%@=nil] ",attributeName];
			}
			
		}
	}
	
	NSString *customDesc = [self customDescription];
	NSString *desc;
	
	if (customDesc && [customDesc length] > 0 ) {
		desc = [NSString stringWithFormat:@"%@:{%@,%@}",[self class],attrsDesc,customDesc];
	}else {
		desc = [NSString stringWithFormat:@"%@:{%@}",[self class],attrsDesc];
	}
    
	return desc;
}

/**
 *  Set value for key in JSONDictionary.
 *  @param dataDic Input the JSONDictionary
 */
-(void)setAttributes:(NSDictionary*)dataDic{
	NSDictionary *attrMapDic = [self attributeMapDictionary];
    
	if (attrMapDic == nil) {
        // If the subclass have no define attributeMapDictionary, we set keys and values to be the same string in attrMapDic.
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[dataDic count]];
        for (NSString *key in dataDic) {
            [dic setValue:key forKey:key];
            attrMapDic = dic;
        }
	}
    
    // deliver JKDictionary parameters to model setters.
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	while ((attributeName = [keyEnum nextObject])) {
		SEL sel = [self getSetterSelectorWithAttributeName:attributeName];
		if ([self respondsToSelector:sel]) {
			NSString *dataDicKey = [attrMapDic objectForKey:attributeName];
            id attributeValue = [dataDic objectForKey:dataDicKey];
            
            // What do you want to do?
            //            if (attributeValue == nil) {
            //                if ([attributeName isEqualToString:@"body"]) {
            //                    continue;
            //                }
            //                attributeValue = @"";
            //            }
            
			[self performSelectorOnMainThread:sel
                                   withObject:attributeValue
                                waitUntilDone:[NSThread isMainThread]];
		}
	}
}

#pragma mark - NSCoding protocol
/**
 *  Decoder, MUST be implemented for NSCoding.
 */
- (id)initWithCoder:(NSCoder *)aDecoder{
	if( self = [super init] ){
		NSDictionary *attrMapDic = [self attributeMapDictionary];
		if (attrMapDic == nil) {
			return self;
		}
		NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
		id attributeName;
		while ((attributeName = [keyEnum nextObject])) {
			SEL sel = [self getSetterSelectorWithAttributeName:attributeName];
			if ([self respondsToSelector:sel]) {
				id obj = [aDecoder decodeObjectForKey:attributeName];
				[self performSelectorOnMainThread:sel
                                       withObject:obj
                                    waitUntilDone:[NSThread isMainThread]];
			}
		}
	}
	return self;
}

/**
 *  Encoder, MUST be implemented for NSCoding.
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
	NSDictionary *attrMapDic = [self attributeMapDictionary];
	if (attrMapDic == nil) {
		return;
	}
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	while ((attributeName = [keyEnum nextObject])) {
		SEL getSel = NSSelectorFromString(attributeName);
		if ([self respondsToSelector:getSel]) {
			NSMethodSignature *signature = nil;
			signature = [self methodSignatureForSelector:getSel];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:self];
			[invocation setSelector:getSel];
			NSObject *valueObj = nil;
			[invocation invoke];
			[invocation getReturnValue:&valueObj];
			
			if (valueObj) {
				[aCoder encodeObject:valueObj forKey:attributeName];
			}
		}
	}
}

/**
 *  Get Archived Data
 */
- (NSData *)getArchivedData {
	return [NSKeyedArchiver archivedDataWithRootObject:self];
}

/**
 * Clean string "\n" and "\r" .
 */
- (NSString *)cleanString:(NSString *)str {
    if (str == nil) {
        return @"";
    }
    NSMutableString *cleanString = [NSMutableString stringWithString:str];
    [cleanString replaceOccurrencesOfString:@"\n" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    [cleanString replaceOccurrencesOfString:@"\r" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    return cleanString;
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    //    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end

//
//  NSString+BPUtil.m
//  BreakPointDownload
//
//  Created by 黄亚州 on 2017/5/30.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "NSString+BPUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (BPUtil)

- (NSString *)MD5String
{
    if([self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
    
}

// 仅保留 string 前的字符
- (NSString *)deleteString:(NSString*)string{
    
    NSRange range = [self rangeOfString:string];
    
    if (range.length > 0) {
        return [self substringToIndex:range.location];
    }
    
    return self;
}

// 仅保留 string 后的字符
- (NSString *)deleteBeforeString:(NSString*)string{
    
    NSRange range = [self rangeOfString:string];
    
    if (range.length > 0) {
        return [self substringFromIndex:range.length + range.location];
    }
    
    return self;
}

- (BOOL)checkBlankString
{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

@end

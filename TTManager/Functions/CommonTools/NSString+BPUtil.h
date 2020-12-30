//
//  NSString+BPUtil.h
//  BreakPointDownload
//
//  Created by 黄亚州 on 2017/5/30.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BPUtil)

- (NSString *)MD5String;

// 仅保留 string 前的字符
- (NSString *)deleteString:(NSString*)string;

// 仅保留 string 后的字符
- (NSString *)deleteBeforeString:(NSString*)string;

- (BOOL)checkBlankString;

@end

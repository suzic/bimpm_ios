//
//  NSString+Extend.m
//  TTManager
//
//  Created by chao liu on 2021/1/16.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)

-(NSString *)urlAddCompnentForValue:(NSString *)value key:(NSString *)key{
    NSMutableString *string = [[NSMutableString alloc]initWithString:self];
        @try {
            NSRange range = [string rangeOfString:@"?"];
            if (range.location != NSNotFound) {//找到了
                //如果?是最后一个直接拼接参数
                if (string.length == (range.location + range.length)) {
                    NSLog(@"最后一个是?");
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
                }else{//如果不是最后一个需要加&
                    if([string hasSuffix:@"&"]){//如果最后一个是&,直接拼接
                        string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
                    }else{//如果最后不是&,需要加&后拼接
                        string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
                    }
                }
            }else{//没找到
                if([string hasSuffix:@"&"]){//如果最后一个是&,去掉&后拼接
                    string = (NSMutableString *)[string substringToIndex:string.length-1];
                }
                string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"?%@=%@",key,value]];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    return string.copy;
}
// Base64编码方法2
- (NSString *)base64EncodingString{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];;
}

// Base64解码方法2
- (NSString *)base64DecodingString{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end

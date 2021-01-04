//
//  NSDictionary+Extend.m
//  TTManager
//
//  Created by chao liu on 2021/1/4.
//

#import "NSDictionary+Extend.h"

@implementation NSDictionary (Extend)
+ (NSDictionary *)nullDic:(NSDictionary *)dic{
    NSArray *keyArr = [dic allKeys];
       NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
       for (int i = 0; i < keyArr.count; i ++)
       {
           id obj = [dic objectForKey:keyArr[i]];
           obj = [self changeType:obj];
           [resDic setObject:obj forKey:keyArr[i]];
       }
       return resDic;
}
//将NSDictionary中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr{
    
   NSMutableArray *resArr = [[NSMutableArray alloc] init];
   for (int i = 0; i < myArr.count; i ++)
   {
       id obj = myArr[i];
       obj = [self changeType:obj];
       [resArr addObject:obj];
   }
   return resArr;
}

//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string{
   return string;
}
+ (NSNumber *)numberToNumber:(NSNumber *)number{
    return number;
}
//将Null类型的项目转化成@""
+(NSString *)nullToString{
   return @"";
}
+(id)changeType:(id)myObj
{
   if ([myObj isKindOfClass:[NSDictionary class]]){
       return [self nullDic:myObj];
   }
   else if([myObj isKindOfClass:[NSArray class]]){
       return [self nullArr:myObj];
   }
   else if([myObj isKindOfClass:[NSString class]]){
       return [self stringToString:myObj];
   }
   else if([myObj isKindOfClass:[NSNull class]]){
       return [self nullToString];
   }
   else if([myObj isKindOfClass:[NSNumber class]]){
       return [self numberToNumber:myObj];
   }
   else{
       if (!myObj) {
           return [self nullToString];
       }
       NSString *trimedString = [myObj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
       if ([trimedString length] == 0)
           // empty string
           return [self nullToString];
       else if ([trimedString isEqualToString:@"null"])
           // is neither empty nor null
           return [self nullToString];
       else if ([trimedString isEqualToString:@"(null)"])
           // is neither empty nor null
           return [self nullToString];
       else if ([trimedString isEqualToString:@"<null>"])
           // is neither empty nor null
           return [self nullToString];
       return myObj;
   }
}
@end

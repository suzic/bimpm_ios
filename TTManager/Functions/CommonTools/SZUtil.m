//
//  SZUtil.m
//  classonline
//
//  Created by 苏智 on 2017/3/21.
//  Copyright © 2017年 offcn. All rights reserved.
//

#import "SZUtil.h"
#import "sys/utsname.h"
#include <sys/param.h>
#include <sys/mount.h>

@implementation SZUtil

+ (NSString*)getGUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    uuid = [uuid lowercaseString];
    CFRelease(uuid_string_ref);
    return uuid;
}

+ (NSString *)getUUID
{
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    identifierStr = [identifierStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return identifierStr;
}

+ (BOOL)isStringContainNumberWith:(NSString *)str
{
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[0-9]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}

/*************************************************
 Function:       // timestamp
 Description:    // 获取时间戳
 Input:          //
 Return:         // timestamp 时间戳
 Others:         //
 *************************************************/
+ (NSTimeInterval)timestamp
{
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    return timestamp;
}

/*************************************************
 Function:       // isValidateEmail
 Description:    // 邮箱验证
 Input:          // email 被检测文本
 Return:         //
 Others:         //
 *************************************************/
/*邮箱验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*************************************************
 Function:       // isValidateEmail
 Description:    // 手机号验证
 Input:          // mobileNum 被检测文本
 Return:         //
 Others:         //
 *************************************************/
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    // 去除空格
    if (mobileNum)
        mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([mobileNum length] != 11) //不为11位 不是手机号
        return NO;
    //运用正则匹配
    NSString *patternStr = [NSString stringWithFormat:@"^(0?1[0-9]\\d{9})$|^((0(10|2[1-3]|[3-9]\\d{2}))?[1-9]\\d{6,7})$"];
    NSRegularExpression *regularexpression=[[NSRegularExpression alloc]initWithPattern:patternStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
    NSUInteger numberOfMatch = [regularexpression numberOfMatchesInString:mobileNum
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, mobileNum.length)];
    if (numberOfMatch > 0)
        return YES;
    return NO;
}

/*************************************************
 Function:       // getTimeNow
 Description:    // 获取当前时间
 Input:          //
 Return:         // timeNow当前时间
 Others:         //
 *************************************************/
+ (NSString *)getTimeNow
{
    NSDate* date = [NSDate date];
    return [self getTimeString:date];
}
+ (NSString *)getDateString:(NSDate *)date
{
    return [self getTimeString:date withDateFormat:@"yyyy-MM-dd"];
}
+ (NSString *)getTimeString:(NSDate *)date
{
    return [self getTimeString:date withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)getTimeStringNoSec:(NSDate *)date
{
    return [self getTimeString:date withDateFormat:@"yyyy-MM-dd HH:mm"];
}
+ (NSString *)getTimeString:(NSDate *)date withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}
+ (NSString *)getShortTimeString:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* timeString = [formatter stringFromDate:date];
    return timeString;
}
+ (NSString *)getTimeLengthString:(NSTimeInterval)length
{
    NSInteger len = (NSInteger)length;
    NSString *stringOutput = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)(len / 3600), (long)(len / 60 % 60), (long)(len % 60)];
    return stringOutput;
}
+ (NSString *)getTimeLengthStringNoHour:(NSTimeInterval)length
{
    NSInteger len = (NSInteger)length;
    NSString *stringOutput = [NSString stringWithFormat:@"%02ld:%02ld", (long)(len / 60), (long)(len % 60)];
    return stringOutput;
}
+ (NSInteger)getTimePeroid:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"hh"];
    NSString* timeString = [formatter stringFromDate:date];
    NSInteger hour = [timeString integerValue];
    if (hour >= 18)
        return 0;
    if (hour < 12)
        return 2;
    return 1;
}

+ (NSDate *)dateFromStr:(NSString *)str withFormatterStr:(NSString *)fStr
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = fStr;
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate *date = [df dateFromString:str];
    if (date == nil) {
        NSLog(@"dateFromStr 参数格式不对！！");
    }
    return date;
}
+ (NSString*)getCurrentWeekDay{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return [self getWeekDayFordate:interval];
}
+ (NSString *)getWeekDayFordate:(NSTimeInterval)data {
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];

    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}
/*************************************************
 Function:       // base64forData
 Description:    // 将数据转成base64
 Input:          //
 Return:         // theData 被转换数据
 Others:         //
 *************************************************/
+ (NSString*)base64forData:(NSData*)theData
{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3)
    {
        NSInteger value = 0;
        for (NSInteger i2 = 0; i2 < 3; i2++)
        {
            value <<= 8;
            if (i + i2 < length)
                value |= (0xFF & input[i + i2]);
        }
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

// Encode Chinese to ISO8859-1 in URL
+ (NSString *)EncodeUTF8Str:(NSString *)encodeStr
{
    /*CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");
     NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingUTF8));
     NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8));
     return newStr;*/
    return @"未被调用";
}

// 根据颜色生成相应的图片
+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 32.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 判断各种空字符串
+ (BOOL)isEmptyOrNull:(NSString *) str
{
    if (!str) // null object
        return YES;
    else if (str == (id)[NSNull null])
        return YES;
    else
    {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([trimedString length] == 0)
            // empty string
            return YES;
        else if ([trimedString isEqualToString:@"null"])
            // is neither empty nor null
            return YES;
        else if ([trimedString isEqualToString:@"(null)"])
            // is neither empty nor null
            return YES;
        else if ([trimedString isEqualToString:@"<null>"])
            // is neither empty nor null
            return YES;
        else
            return NO;
    }
}

+ (BOOL) isConnectionAvailable
{
    BOOL isExistenceNetwork = YES;
    //    Reachability *reach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    //    switch ([reach currentReachabilityStatus]) {
    //        case NotReachable:
    //            isExistenceNetwork = NO;
    //            //NSLog(@"notReachable");
    //            break;
    //        case ReachableViaWiFi:
    //            isExistenceNetwork = YES;
    //            //NSLog(@"WIFI");
    //            break;
    //        case ReachableViaWWAN:
    //            isExistenceNetwork = YES;
    //            //NSLog(@"3G");
    //            break;
    //    }
    
    return isExistenceNetwork;
}

+ (NSString *)wrapHtmlFormat:(NSString *)stringHTML limitHeight:(BOOL)limitHeight underWidth:(CGFloat)width
{
    if ([self isEmptyOrNull:stringHTML])
        return @"";
    
    BOOL isCherkParsing = ([stringHTML rangeOfString:@"【题目得分】 "].location !=NSNotFound)?YES:NO;
    NSString *cssFormat = limitHeight
    ? [NSString stringWithFormat:@"body {font-family:\"%@\"; font-size:%dpx; font-weight:300;}"
       "img {max-height:%dpx}",
       @"-apple-system", 64, 64 * 2]
    : [NSString stringWithFormat:@"body {font-family:\"%@\"; font-size:%dpx; font-weight:300;}"
       "img {max-width:%dpx; max-height:}",
       @"-apple-system", ((kScreenWidth == 320) && isCherkParsing)?58:44, ((int)width - 16) * 2];
    
    NSString *convertString = [NSString stringWithFormat:
                               @"<html>"
                               "<head><style type=\"text/css\">%@</style></head>"
                               "<body>%@</body>"
                               "</html>",
                               cssFormat, stringHTML];
    
    NSArray *explanationArray = [stringHTML componentsSeparatedByString:@"\n"];
    if (isCherkParsing) {//解析
        
        if (explanationArray.count > 4) {
            convertString = [NSString stringWithFormat:
                             @"<html>"
                             "<head><style type=\"text/css\">%@</style></head>"
                             "<br>%@<br><br>%@<br><br>%@<br><br>%@<br><br>"
                             "<body>%@<br></body>"
                             "</html>",
                             cssFormat,explanationArray[0],explanationArray[1],explanationArray[2],explanationArray[3],[explanationArray lastObject]];
        }else if (explanationArray.count == 2){
            convertString = [NSString stringWithFormat:
                             @"<html>"
                             "<head><style type=\"text/css\">%@</style></head>"
                             "<br>%@<br><br>"
                             "<body>%@<br></body>"
                             "</html>",
                             cssFormat,explanationArray[0],[explanationArray lastObject]];
        }
        
    }
    return convertString;
}

+ (NSInteger)SelectTheServerUrl
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"NetworkInterface.plist"];
    NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    NSString *vserStr = [dataDic objectForKey:@"SwitchServer"];
    if (vserStr == nil || [vserStr isEqualToString:@"0"] || [vserStr isEqualToString:@""])
        return 0;
    else if ([vserStr isEqualToString:@"1"])
        return 1;
    return 2;
}

+ (NSDate *)startDate:(NSDate *)date offsetDay:(int)numDays
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2]; //monday is first day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
}

static NSDateFormatter *fullTimeFormatter;
+ (NSDateFormatter *)dateFormatterFullTime
{
    if (fullTimeFormatter == nil)
    {
        fullTimeFormatter = [[NSDateFormatter alloc] init];
        [fullTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return fullTimeFormatter;
}

static NSDateFormatter *dayFormatter;
+ (NSDateFormatter *)dateFormatterDay
{
    if (dayFormatter == nil)
    {
        dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return dayFormatter;
}

// 获取消息字典
- (NSMutableDictionary *)getDocumentsDirectory
{
    NSString *plistPath = [self AccessToLocalFilePath];
    NSMutableDictionary *plistDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    NSMutableDictionary *dic = [plistDic objectForKey:@"message"];
    
    // 如果本地plist文件没有消息记录，则新建一个消息字典
    if ([dic allKeys] == 0)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"messageCode",@"",@"isread", nil];
        [plistDic setObject:dic forKey:@"message"];
        [plistDic writeToFile:plistPath atomically:YES];
    }
    return plistDic;
}

// 获取本地文件路径
- (NSString *)AccessToLocalFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"NetworkInterface.plist"];
    
    return plistPath;
}

- (void)writeDataToLocationToPlist:(NSMutableDictionary *)dataDic
{
    NSString *plistPath = [self AccessToLocalFilePath];
    [dataDic writeToFile:plistPath atomically:YES];
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (CIImage *)createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

+ (NSString*)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    
    if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone9,1"]) return @"iPhone 7 (CDMA)";
    if ([deviceString isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus (CDMA)";
    if ([deviceString isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (GSM)";
    if ([deviceString isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus (GSM)";
    
    if ([deviceString isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([deviceString isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([deviceString isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([deviceString isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([deviceString isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([deviceString isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([deviceString isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([deviceString isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([deviceString isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([deviceString isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([deviceString isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([deviceString isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([deviceString isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([deviceString isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([deviceString isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([deviceString isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([deviceString isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([deviceString isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([deviceString isEqualToString:@"iPad4,7"])  return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])  return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])  return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])  return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])  return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])  return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])  return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])  return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])  return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])  return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])  return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"]) return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"]) return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])  return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])  return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])  return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])  return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    
    if ([deviceString isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return deviceString;
    //    //设备唯一标识符
    //    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //    NSLog(@"设备唯一标识符:%@",identifierStr);
    //    //手机别名： 用户定义的名称
    //    NSString* userPhoneName = [[UIDevice currentDevice] name];
    //    NSLog(@"手机别名: %@", userPhoneName);
    //    //设备名称
    //    NSString* deviceName = [[UIDevice currentDevice] systemName];
    //    NSLog(@"设备名称: %@",deviceName );
    //    //手机系统版本
    //    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //    NSLog(@"手机系统版本: %@", phoneVersion);
    //    //手机型号
    //    NSString * phoneModel =  [self deviceVersion];
    //    NSLog(@"手机型号:%@",phoneModel);
    //    //地方型号  （国际化区域名称）
    //    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    //    NSLog(@"国际化区域名称: %@",localPhoneModel );
    //    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    // 当前应用软件版本  比如：1.0.1
    //    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //    NSLog(@"当前应用软件版本:%@",appCurVersion);
    //    // 当前应用版本号码   int类型
    //    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    //    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    //    CGRect rect = [[UIScreen mainScreen] bounds];
    //    CGSize size = rect.size;
    //    CGFloat width = size.width;
    //    CGFloat height = size.height;
    //    NSLog(@"物理尺寸:%.0f × %.0f",width,height);
    //    CGFloat scale_screen = [UIScreen mainScreen].scale;
    //    NSLog(@"分辨率是:%.0f × %.0f",width*scale_screen ,height*scale_screen);
    //    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    //    CTCarrier *carrier = info.subscriberCellularProvider;
    //    NSLog(@"运营商:%@", carrier.carrierName);
    //    [objc] view plain copy
}
+ (NSString *)app_target_name{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    CFShow((__bridge CFTypeRef)(infoDictionary));
      // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}
#pragma mark - imageToTransparent

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL)
        {
            if( temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys)
    {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    const char *ptr = [signString UTF8String];
    int i =0;
    unsigned int len = (unsigned int) strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        byteArray[i] = low8Bits;
        i++;
    }
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *result = [NSString stringWithString:hex];
    NSLog(@"--- Gen sign: %@", result);
    return result;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)showSizeInfo:(int64_t)sizeCount
{
    NSInteger level = 0;
    CGFloat convertSize = sizeCount;
    while (convertSize > 1000 && level < 4)
    {
        level++;
        convertSize = convertSize / 1024.0f;
    }
    NSString *tail = nil;
    switch (level)
    {
        case 0:
            tail = @"B";
            break;
        case 1:
            tail = @"KB";
            break;
        case 2:
            tail = @"MB";
            break;
        case 3:
            tail = @"GB";
            break;
        case 4:
            tail = @"TB";
            break;
        case 5:
        default:
            tail = @"PB";
            break;
    }
    return [NSString stringWithFormat:@"%02.2f%@", convertSize, tail];
}

// 根据图片url获取图片尺寸
+ (CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    __block CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:URL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage* image = [UIImage imageWithData:data];
            if(image)
            {
                size = image.size;
            }
            dispatch_semaphore_signal(semaphore);//发送信号
            
        }];
        [dataTask resume];
        dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    }
    return size;
}
//  获取PNG图片的大小
+ (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    __block NSData *data;
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable imageData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        data = imageData;
        dispatch_semaphore_signal(semaphore);//发送信号
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+ (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    __block NSData *data;
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable imageData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        data = imageData;
        dispatch_semaphore_signal(semaphore);//发送信号
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+ (CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    __block NSData *data;
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable imageData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        data = imageData;
        dispatch_semaphore_signal(semaphore);//发送信号
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

+ (CGSize)autoFitSizeOfStr:(NSString *)str withWidth:(CGFloat)width withFont:(UIFont *)font {
    if (nil == str) {
        str = @" ";
    }
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [str boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

+ (CGSize)autoFitSizeOfStr:(NSString *)str withWidth:(CGFloat)width withFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing {
    if (nil == str) {
        str = @" ";
    }
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:lineSpacing];
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [str boundingRectWithSize:CGSizeMake(width, 3000) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

+ (UIColor *)appStandardColor
{
    // return [UIColor colorWithRed:0.0f green:122.0f/256.0f blue:1.0f alpha:1.0f];
    return [self colorWithHex:@"#46A2D3"];
}

+ (NSString *)timeStampToTimeString:(long long)timeStamp withDateFormat:(NSString *)formatStr {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:formatStr];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString* timeStr = [formatter stringFromDate:date];
    return timeStr;
}


// 读取plist文件数据（可以选择从MainBundle或者Document中读取）
+ (id)getPlistData:(NSString *)key inFile:(NSString *)filename inDocScope:(BOOL)inDocument
{
    NSString *plistPath = nil;
    if (inDocument)
    {
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [pathArray firstObject];
        plistPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", filename]];
    }
    else
    {
        NSBundle *bundle = [NSBundle mainBundle];
        plistPath = [bundle pathForResource:filename ofType:@"plist"];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return [dict objectForKey:key];
}

// 写入plist文件数据（只能写入Document沙盒）
+ (void)setPlistDataValue:(id)objectValue forKey:(NSString *)key inFile:(NSString *)filename
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray firstObject];
    NSString *plistPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", filename]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [dict setObject:objectValue forKey:key];
    [dict writeToFile:plistPath atomically:YES];
}

+ (UIColor *)colorWithHex:(NSString *)hexColor {
    return [self colorWithHex:hexColor withAlpha:1.0f];
}

+ (UIColor *)colorWithHex:(NSString *)hexColor withAlpha:(CGFloat)alpha {
    if (!hexColor || hexColor.length == 0)
        return [UIColor whiteColor];
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    UIColor *color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
    return color;
}

+ (UIColor *)textPlaceholderColor {
    return [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.5];
}

+ (BOOL)checkEmailFormatValid:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailCheck evaluateWithObject:emailStr];
}

+ (long long)freeDiskSpace {
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}

+ (long long)totalDiskSpace {
    struct statfs buf;
    long long totalSpace = 0;
    if (statfs("/var", &buf) >= 0) {
        totalSpace = (long long)buf.f_bsize * buf.f_blocks;
    }
    //    NSError *error = nil;
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    //    NSNumber *total = [dictionary objectForKey:NSFileSystemSize];
    //    totalSpace = [total unsignedLongLongValue];
    return totalSpace;
}

+ (long long)getFileSize:(NSString*)path
{
    NSFileManager * filemanager = [NSFileManager defaultManager];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize longLongValue];
        else
            return 0;
    }
    else
    {
        return 0;
    }
}

// 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

// 获取根视图
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController])
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    
    if ([rootVC isKindOfClass:[UITabBarController class]])
    {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }
    else
    {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}
+ (id)convertToJsonData:(NSMutableDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    return jsonData;
//    NSString *jsonString;
//    if (!jsonData) {
//        NSLog(@"%@",error);
//    }else{
//        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }
//    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
//    NSRange range = {0,jsonString.length};
//    //去掉字符串中的空格
//    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
//    NSRange range2 = {0,mutStr.length};
//    //去掉字符串中的换行符
//    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
//    NSLog(@"当前转化的字符串%@",mutStr);
//    return mutStr;
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (BOOL)inputShouldNumber:(NSString *)inputString {
    if (inputString.length == 0)
        return NO;
    NSString *regex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

+ (BOOL)isAllowLocationService
{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways))
    {
        //定位功能可用
        return YES;
    }
    else// if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        //定位不能用
        return NO;
    }
}

+ (NSString *)getYYYYMMDD:(NSDate *)date type:(NSInteger)type{
    NSString *time = @"";
    if (type == 1) {
        NSString *YYYYMMDD = [SZUtil getDateString:date];
        YYYYMMDD = [YYYYMMDD stringByAppendingString:@" 00:00:00:000"];
        NSDate *YYYYMMDDdate = [NSDate br_dateFromString:YYYYMMDD dateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
        NSTimeInterval timeInterval = [YYYYMMDDdate timeIntervalSince1970];
        time = [NSString stringWithFormat:@"%.0f", timeInterval*1000];
    }else if(type == 2){
       time = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]*1000];
    }
    return time;
}
@end

//
//  SZUtil.h
//  classonline
//
//  Created by 苏智 on 2017/3/21.
//  Copyright © 2017年 offcn. All rights reserved.
//

#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface SZUtil : NSObject

+ (NSString *)getGUID;
/**
 * @abstract 获取uuid
 */
+ (NSString*)getUUID;

/**
 * @abstract 判断字符串中是否包含数字
 */
+ (BOOL)isStringContainNumberWith:(NSString *)str;

/**
 * @abstract 获取当前时间戳
 */
+ (NSTimeInterval)timestamp;

/**
 * @abstract 获取当前时间的字符串
 */
+ (NSString *)getTimeNow;
+ (NSString *)getDateString:(NSDate *)date;
+ (NSString *)getTimeString:(NSDate *)date;
+ (NSString *)getTimeStringNoSec:(NSDate *)date;

/**
 * @description 获取时间格式的字符串
 * @param date 时间
 * @param dateFormat 时间格式
 */
+ (NSString *)getTimeString:(NSDate *)date withDateFormat:(NSString *)dateFormat;
+ (NSInteger)getTimePeroid:(NSDate *)date;
+ (NSString *)getShortTimeString:(NSDate *)date;
+ (NSString *)getTimeLengthString:(NSTimeInterval)length;
+ (NSString *)getTimeLengthStringNoHour:(NSTimeInterval)length;
+ (NSDate *)dateFromStr:(NSString *)str withFormatterStr:(NSString *)fStr;
+ (NSString*)getCurrentWeekDay;
+ (NSDate *)getTimeDate:(NSString *)str;
/**
 * @abstract 判断邮箱
 */
+(BOOL)isValidateEmail:(NSString *)email;

/**
 * @abstract 判断手机号
 */
+(BOOL) isMobileNumber:(NSString *)mobileNum;
+(NSString *)EncodeUTF8Str:(NSString *)encodeStr;

/**
 * @abstract 根据三色值生成图片
 */
+ (UIImage *)createImageWithColor: (UIColor *) color;

/**
 * @abstract 判断字符床是否为空
 */
+ (BOOL)isEmptyOrNull:(NSString *) str;

/**
 * @abstract 判断当前是否有网络
 */
+ (BOOL)isConnectionAvailable;

+ (NSString *)wrapHtmlFormat:(NSString *)stringHTML limitHeight:(BOOL)limitHeight underWidth:(CGFloat)width;

/**
 * @abstract 替换服务器
 */
+ (NSInteger)SelectTheServerUrl;

/**
 * @abstract 计算明天的日期
 */
+ (NSDate *)startDate:(NSDate *)date offsetDay:(int)numDays;

/**
 * @abstract iOS设备的型号名称
 */
+ (NSString *)deviceVersion;
+ (NSString *)app_target_name;
+ (NSString *)showSizeInfo:(int64_t)sizeCount;

+ (NSDateFormatter *)dateFormatterFullTime;
+ (NSDateFormatter *)dateFormatterDay;

+ (CIImage *)createQRForString:(NSString *)qrString;

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

+ (UIImage *)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

+ (NSString *)genSign:(NSDictionary *)signParams;

+ (NSString *)md5:(NSString *)str;

/**
 * @description 根据图片url获取图片尺寸
 * @param imageURL 图片url
 */
+ (CGSize)getImageSizeWithURL:(id)imageURL;
//字符串尺寸
+ (CGSize)autoFitSizeOfStr:(NSString *)str withWidth:(CGFloat)width withFont:(UIFont *)font;
+ (CGSize)autoFitSizeOfStr:(NSString *)str withWidth:(CGFloat)width withFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing;
/** 在线课堂 标准颜色 */
+ (UIColor *)appStandardColor;

/**
 * @description 时间戳换成时间字符串
 * @param timeStamp 时间戳
 * @param formatStr 时间格式
 */
+ (NSString *)timeStampToTimeString:(long long)timeStamp withDateFormat:(NSString *)formatStr;

// 读取plist文件数据（可以选择从MainBundle或者Document中读取）
+ (id)getPlistData:(NSString *)key inFile:(NSString *)filename inDocScope:(BOOL)inDocument;

// 写入plist文件数据（只能写入Document沙盒）
+ (void)setPlistDataValue:(id)objectValue forKey:(NSString *)key inFile:(NSString *)filename;

/**
 * @description 十六进制的颜色
 * @param hexColor 十六进制的数值
 */
+ (UIColor *)colorWithHex:(NSString *)hexColor;
/**
 * @description 十六进制的颜色
 * @param hexColor 十六进制的数值
 * @param alpha alpha值
 */
+ (UIColor *)colorWithHex:(NSString *)hexColor withAlpha:(CGFloat)alpha;

// UITextField Placeholder Color
+ (UIColor *)textPlaceholderColor;
/**
 * @description 检测邮箱地址是否有效
 * @param emailStr 邮箱地址
 */
+ (BOOL)checkEmailFormatValid:(NSString *)emailStr;
/**
 * @description 获取空闲磁盘空间大小
 */
+ (long long)freeDiskSpace;
/**
 * @description 获取空闲磁盘空间大小
 */
+ (long long)totalDiskSpace;
/**
 * @description 获取指定文件的大小
 * @param path 文件路径
 */
+ (long long)getFileSize:(NSString*)path;

/**
 * @description 获取当前屏幕显示的viewcontroller
 */
+ (UIViewController *)getCurrentVC;

/// 字典转json
/// @param dict 字典
+ (id)convertToJsonData:(NSMutableDictionary *)dict;

/// 字符串转字典
/// @param jsonString 字符串
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (BOOL)inputShouldNumber:(NSString *)inputString;

+ (BOOL)isAllowLocationService;


/// 获取日期时间戳，格式为YYYYMMDD 00:00:00
/// @param date 需要处理的时间
/// @param type 需要的数据类型 1：YYYYMMMDD 2：YYYYMMDD HH:mm:ss:SSS"
+ (NSString *)getYYYYMMDD:(NSDate *)date type:(NSInteger)type;

/// 去除文本中的html标签
/// @param htmlString 文本内容
+ (NSString *)removeHtmlWithString:(NSString *)htmlString;

/// 获取字符串中的中文
/// @param string 原字符串
+ (NSString *)getChineseInString:(NSString *)string;
@end

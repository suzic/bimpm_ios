//
//  UploadFileManager.h
//  TTManager
//
//  Created by chao liu on 2021/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UploadFileResult)(BOOL success,NSString *errMsg,NSString *id_file);

@interface UploadFileManager : NSObject

@property (nonatomic,copy)UploadFileResult uploadResult;
/// 上传图片到文件目录 并且新建target
/// @param imageData 图片
/// @param fileName 图片名称
- (void)uploadFile:(NSData *)imageData fileName:(NSString *)fileName target:(NSDictionary *)target;
/// 新建一个文件目录
/// @param fileName 目录名称
/// @param ZHTarget 目录所属ZHTarget
- (void)newFileGroupWithGroupName:(NSString *)fileName target:(NSDictionary *)target;

@end

NS_ASSUME_NONNULL_END

//
//  APIUploadFileManager.h
//  TTManager
//
//  Created by chao liu on 2021/1/14.
//

#import "BaseApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIUploadFileManager : BaseApiManager<APIManager,APIManagerValidator>

/// 需要上传的文件数据，格式@{@"name":@"",@"type":@"image/json",@"data":@""}
@property (nonatomic, strong) NSMutableArray *uploadArray;

@end

NS_ASSUME_NONNULL_END

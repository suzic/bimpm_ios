//
//  APIUploadFileManager.h
//  TTManager
//
//  Created by chao liu on 2021/1/14.
//

#import "BaseApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIUploadFileManager : BaseApiManager<APIManager,APIManagerValidator>

@property (nonatomic, strong) NSMutableArray *uploadArray;

@end

NS_ASSUME_NONNULL_END
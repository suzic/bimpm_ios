//
//  APIFileDownLoadManager.h
//  TTManager
//
//  Created by chao liu on 2021/1/25.
//

#import "BaseApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIFileDownLoadManager : BaseApiManager<APIManager,APIManagerValidator>
// 当前下载的uid_target
@property (nonatomic,copy) NSString *uid_target;

@end

NS_ASSUME_NONNULL_END

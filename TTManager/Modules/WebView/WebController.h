//
//  WebController.h
//  TTManager
//
//  Created by chao liu on 2020/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebController : UIViewController

@property (nonatomic, copy)NSString *loadUrl;
/// 查看文件附件
/// @param fileViewDic 文件属性 @{@"uid_target":@"",@"v":@"",@"t":@"",@"m":@"",@"f":@""}
- (void)fileView:(NSDictionary *)fileViewDic;
@end

NS_ASSUME_NONNULL_END

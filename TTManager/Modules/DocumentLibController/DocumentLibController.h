//
//  DocumentLibController.h
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^selectedTargetBlock)(ZHTarget *target);

@interface DocumentLibController : UIViewController

@property (nonatomic, copy)selectedTargetBlock targetBlock;
// YES 选中文件返回 ， NO，选中文件查看详情
@property (nonatomic, assign) BOOL chooseTargetFile;

- (void)loadFileCatalogCollectionView;
- (void)fileViewListEmpty:(BOOL)empty;

@end

NS_ASSUME_NONNULL_END

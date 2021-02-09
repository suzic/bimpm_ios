//
//  FormItemSectionView.h
//  TTManager
//
//  Created by chao liu on 2021/2/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormItemSectionView : UITableViewHeaderFooterView

/// 设置表单item
/// @param isFormEdit 是否可编辑
/// @param indexPath 当前的下标
/// @param formItem 当前的数据
- (void)setIsFormEdit:(BOOL)isFormEdit
            indexPath:(NSIndexPath *)indexPath
                 item:(NSDictionary *)formItem;

@end

NS_ASSUME_NONNULL_END

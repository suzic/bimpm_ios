//
//  FormEditCell.h
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormEditCell : UITableViewCell

/// 固定模版类型 1施工日志 2 工作日志
@property (nonatomic, assign) NSInteger templateType;

/// 巡检任务中的巡检单
@property (nonatomic, assign) BOOL isPollingTask;

/// 表头系统名称
/// @param data @{@"name":@"",@"instance_value":@""}
- (void)setHeaderViewData:(NSDictionary *)data;

/// 设置表单item
/// @param isFormEdit 是否可编辑
/// @param indexPath 当前的下标
/// @param formItem 当前的数据
- (void)setIsFormEdit:(BOOL)isFormEdit
            indexPath:(NSIndexPath *)indexPath
                 item:(NSDictionary *)formItem;
@end

NS_ASSUME_NONNULL_END

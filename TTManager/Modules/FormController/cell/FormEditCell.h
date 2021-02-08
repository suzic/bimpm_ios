//
//  FormEditCell.h
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormEditCell : UITableViewCell

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UITextView *valueTextView;

/// 表头系统名称
/// @param data @{@"name":@"",@"instance_value":@""}
- (void)setHeaderViewData:(NSDictionary *)data;

/// 固定模版类型 1施工日志 2 工作日志
@property (nonatomic, assign) NSInteger templateType;

- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(NSDictionary *)formItem;
@end

NS_ASSUME_NONNULL_END

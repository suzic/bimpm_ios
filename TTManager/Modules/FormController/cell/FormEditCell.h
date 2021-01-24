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
@property (nonatomic, strong) UITextField *valueTextField;

- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(ZHFormItem *)formItem;
@end

NS_ASSUME_NONNULL_END

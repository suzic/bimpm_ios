//
//  FormRowView.h
//  TTManager
//
//  Created by chao liu on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormRowView : UIView

@property (nonatomic, strong) UITextField *keyTextField;
@property (nonatomic, strong) UITextField *valueTextField;
@property (nonatomic, strong) UIButton *formKeyTypeButton;

- (void)changeValueFieldLeft:(BOOL)left;
@end

NS_ASSUME_NONNULL_END

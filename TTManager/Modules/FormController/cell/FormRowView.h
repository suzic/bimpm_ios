//
//  FormRowView.h
//  TTManager
//
//  Created by chao liu on 2021/1/20.
//

#import <UIKit/UIKit.h>
#import "FormItemView.h"

typedef NS_ENUM(NSInteger,FormRowType){
    formRowType_text_text             = 0,
    formRowType_text_textField        = 1,
    formRowType_text_btn              = 2,
    formRowType_text_urlImg           = 3,
    formRowType_textField_textField   = 4,
    formRowType_btn_textField         = 5,
};

NS_ASSUME_NONNULL_BEGIN

@interface FormRowView : UIView

@property (nonatomic, strong) UITextField *keyTextField;
@property (nonatomic, strong) UITextField *valueTextField;
@property (nonatomic, strong) UIButton *formKeyTypeButton;

- (void)setItemRowContent:(id)data type:(FormItemType)itemType edit:(BOOL)edit;

@property (nonatomic, assign) FormItemType itemType;
@property (nonatomic, strong) ZHForm *currentForm;
@property (nonatomic, strong) ZHFormItem *formItem;
@property (nonatomic, assign) BOOL isEdit;

- (void)changeValueFieldLeft:(BOOL)left;

@end

NS_ASSUME_NONNULL_END

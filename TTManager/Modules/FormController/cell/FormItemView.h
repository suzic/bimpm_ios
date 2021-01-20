//
//  FormItemView.h
//  TTManager
//
//  Created by chao liu on 2021/1/20.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FormItemType){
    formItemType_name      = 0,
    formItemType_system    = 1,
    formItemType_content   = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface FormItemView : UIView

- (instancetype)initWithItemType:(FormItemType)itemType;

@property (nonatomic, strong) ZHForm *currentForm;
@property (nonatomic, strong) ZHFormItem *formItem;

@property (nonatomic, assign) BOOL isEdit;

@end

NS_ASSUME_NONNULL_END

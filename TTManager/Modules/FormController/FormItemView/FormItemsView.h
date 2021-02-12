//
//  FormItemsView.h
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,FormItemType){
    formItemType_text    = 0,
    formItemType_btn     = 1,
    formItemType_image   = 2,
    formItemType_slider  = 3,
};

@interface FormItemsView : UIView

/// 当前item的下标
@property (nonatomic, strong) NSIndexPath *indexPath;

/// 设置页面显示类型
/// @param type 当前显示的表单样式
/// @param edit 当前表单是否可编辑
/// @param indexPath 当前表单下标
/// @param data 当前表单数据
- (void)setItemView:(FormItemType)type edit:(BOOL)edit indexPath:(NSIndexPath *)indexPath data:(NSDictionary *)data;

- (UIView *)getViewByType:(FormItemType)type;

@end

NS_ASSUME_NONNULL_END

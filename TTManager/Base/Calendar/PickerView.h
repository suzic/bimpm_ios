//
//  PickerView.h
//  TTManager
//
//  Created by chao liu on 2021/1/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CloseBlock)(void);
typedef void(^SureBlock)(void);

@interface PickerView : UIView

@property (nonatomic, copy)CloseBlock closeBlock;
@property (nonatomic, copy)SureBlock sureBlock;

- (void)normalSelectedDate;

@end

NS_ASSUME_NONNULL_END

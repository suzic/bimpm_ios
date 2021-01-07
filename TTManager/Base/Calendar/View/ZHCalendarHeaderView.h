//
//  ZHCalendarHeaderView.h
//  TTManager
//
//  Created by chao liu on 2021/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CloseBlock)(void);
typedef void(^SureBlock)(void);

@interface ZHCalendarHeaderView : UIView

@property (nonatomic, copy)CloseBlock closeBlock;
@property (nonatomic, copy)SureBlock sureBlock;
- (void)addCornerRadiu;

@end

NS_ASSUME_NONNULL_END

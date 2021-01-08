//
//  SupernatantView.h
//  TTManager
//
//  Created by chao liu on 2021/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SupernatantView : UIView

+ (instancetype)initSupernatantViewInView:(UIView *)view;
- (void)showframe:(CGRect)frame text:(NSString *)text;
@end

NS_ASSUME_NONNULL_END

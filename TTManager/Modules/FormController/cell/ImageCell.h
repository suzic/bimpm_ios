//
//  ImageCell.h
//  TTManager
//
//  Created by chao liu on 2021/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *addButton;

- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(NSString *)imageUrl;
// 隐藏添加按钮
- (void)hideAddButton:(BOOL)hide;

@end

NS_ASSUME_NONNULL_END

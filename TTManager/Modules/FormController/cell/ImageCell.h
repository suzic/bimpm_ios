//
//  ImageCell.h
//  TTManager
//
//  Created by chao liu on 2021/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell : UICollectionViewCell

- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END

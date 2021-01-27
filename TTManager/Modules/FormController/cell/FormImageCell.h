//
//  FormImageCell.h
//  TTManager
//
//  Created by chao liu on 2021/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormImageCell : UITableViewCell

- (void)setIsFormEdit:(BOOL)isFormEdit indexPath:(NSIndexPath *)indexPath item:(NSDictionary *)formItem;

@end

NS_ASSUME_NONNULL_END

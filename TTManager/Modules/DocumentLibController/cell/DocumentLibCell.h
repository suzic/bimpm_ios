//
//  DocumentLibCell.h
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentLibCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *documentIcon;
@property (weak, nonatomic) IBOutlet UILabel *documentTitle;

@end

NS_ASSUME_NONNULL_END

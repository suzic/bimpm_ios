//
//  DateCell.h
//  TTManager
//
//  Created by chao liu on 2021/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeInforLabel;

@end

NS_ASSUME_NONNULL_END

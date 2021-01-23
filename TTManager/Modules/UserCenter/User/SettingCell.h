//
//  SettingCell.h
//  TTManager
//
//  Created by chao liu on 2021/1/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *settingIcon;
@property (weak, nonatomic) IBOutlet UILabel *settingTitle;

@end

NS_ASSUME_NONNULL_END

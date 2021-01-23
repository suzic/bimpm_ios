//
//  PassCell.h
//  TTManager
//
//  Created by chao liu on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *passWordtextField;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordBtn;

@end

NS_ASSUME_NONNULL_END

//
//  VerificationCell.h
//  TTManager
//
//  Created by chao liu on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VerificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationBtn;

@end

NS_ASSUME_NONNULL_END

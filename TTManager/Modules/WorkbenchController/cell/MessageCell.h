//
//  MessageCell.h
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (nonatomic,strong) NSArray *ganntInfoList;

@end

NS_ASSUME_NONNULL_END

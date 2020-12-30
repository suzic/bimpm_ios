//
//  TaskInforCell.h
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskInforCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *tabBgView;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *myTaskBtn;
@property (weak, nonatomic) IBOutlet UIButton *mySendTaskBtn;

@property (weak, nonatomic) IBOutlet UIView *firstItembgView;
@property (weak, nonatomic) IBOutlet UILabel *firstStatusName;
@property (weak, nonatomic) IBOutlet UILabel *firstStatusCount;

@property (weak, nonatomic) IBOutlet UIView *secondItembgView;
@property (weak, nonatomic) IBOutlet UILabel *secondStatusName;
@property (weak, nonatomic) IBOutlet UILabel *secondStatusCount;

@end

NS_ASSUME_NONNULL_END

//
//  TaskListCell.h
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskListCell : UITableViewCell

@property (nonatomic, strong)UILabel *taskName;
@property (nonatomic, strong)UILabel *predictTime;

@end

NS_ASSUME_NONNULL_END

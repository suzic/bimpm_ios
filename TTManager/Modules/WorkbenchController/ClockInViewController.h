//
//  ClockInViewController.h
//  TTManager
//
//  Created by chao liu on 2021/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 1:是否需要克隆当前打卡表单(克隆表单id=basicform-gzrb_105)
 * 2:如果需要克隆，先根据basicform-gzrb_105进行克隆，然后编辑
 * 3:如果不需要克隆，则直接编辑。
 * 规则:
 * 1:“打卡日期（日期时间类型）“不可编辑，直接根据当前系统时间自动填入；
 * “姓名”自动填入当前登录用户的name，不允许修改。
 *2:其他字段分为上班（3个字段）和下班（3个字段），
 *该表单界面有一个上班还是下班选择（默认是中午12点前上班，之后是下班，但考虑特殊情况，用户仍然可以切换），
 *选择后再进行打卡：
 *打卡即为一个按钮，按下时，获取当前时间填写到对应的时间里，
 *获取当前的位置信息，与项目的位置信息比对（相距离1000m以内视为“公司打卡”，否则是“外出打卡”），
 *并根据地图SDK填写位置信息文字。
 */
@interface ClockInViewController : UIViewController

/// 是否需要克隆当前表单
@property (nonatomic, assign) BOOL isCloneForm;

/// 表单buddy_file
@property (nonatomic, strong) NSString *buddy_file;

@end

NS_ASSUME_NONNULL_END

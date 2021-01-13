//
//  OperabilityTools.h
//  TTManager
//
//  Created by chao liu on 2021/1/9.
//

#import <Foundation/Foundation.h>
#import "TaskController.h"

NS_ASSUME_NONNULL_BEGIN

// 当前任务页面可操作的行为
@interface OperabilityTools : NSObject

- (instancetype)initWithType:(TaskType)type;

@property (nonatomic, assign) TaskType type;

@property (nonatomic, strong) ZHTask *task;

@property (nonatomic, strong) NSMutableArray *stepArray;

// 当前选中的步骤(包含默认步骤)
@property (nonatomic, strong) ZHStep *currentSelectedStep;

@property (nonatomic,assign) BOOL isDetails;
// 修改步骤
@property (nonatomic,assign) BOOL operabilityStep;
// 修改任务名称
@property (nonatomic,assign) BOOL operabilityTitle;
// 修改优先级
@property (nonatomic,assign) BOOL operabilityPriority;
// 修改内容
@property (nonatomic,assign) BOOL operabilityContent;
// 修改时间
@property (nonatomic,assign) BOOL operabilityTime;
// 修改附件
@property (nonatomic,assign) BOOL operabilityAdjunct;
// 操作保存
@property (nonatomic,assign) BOOL operabilitySave;
@end

NS_ASSUME_NONNULL_END

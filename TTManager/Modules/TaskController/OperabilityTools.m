//
//  OperabilityTools.m
//  TTManager
//
//  Created by chao liu on 2021/1/9.
//

#import "OperabilityTools.h"

@implementation OperabilityTools
- (instancetype)initWithType:(TaskType)type{
    self = [super init];
    if (self) {
        [self initOperabilityTools:type];
    }
    return self;
}
// 默认任务详情哪些课操作
- (void)initOperabilityTools:(TaskType)type{
    // 默认操作属性全是NO
    [self initProperty];
    
    // 发起任务和起草中的任务可操作所有选项
    if (type == task_type_new_task || type == task_type_new_apply || type == task_type_new_noti || type == task_type_new_joint || type == task_type_new_polling || type == task_type_detail_draft) {
        self.operabilityStep = YES;
        self.operabilityTitle = YES;
        self.operabilitySave = YES;
        self.operabilityContent = YES;
        self.operabilityTime = YES;
        self.operabilityAdjunct = YES;
        self.operabilityPriority = YES;
    }
    // 进行中 和 发起的可操作title 和content 优先级
    if (type == task_type_detail_proceeding || type == task_type_detail_initiate) {
        self.operabilityTitle = YES;
        self.operabilityContent = YES;
        self.operabilityPriority = YES;
    }
    if (type == task_type_detail_finished ||type == task_type_detail_initiate || type == task_type_detail_draft ||type == task_type_detail_proceeding) {
        self.showStepAdd = NO;
        self.isDetails = YES;
    }
}

- (void)initProperty{
    self.stepArray = [NSMutableArray array];
    self.operabilityStep = NO;
    self.operabilityTitle = NO;
    self.operabilitySave = NO;
    self.operabilityContent = NO;
    self.operabilityTime = NO;
    self.operabilityAdjunct = NO;
    self.operabilityPriority = NO;
    self.showStepAdd = YES;
    self.isDetails = NO;
}
#pragma mark - setter and getter
- (void)setTask:(ZHTask *)task{
    if (_task != task) {
        _task = task;
        self.stepArray = [self getCurrentTaskStep:_task];
    }
}
- (NSMutableArray *)getCurrentTaskStep:(ZHTask *)task{
//    [self.stepArray addObject:task.startUser];
    NSMutableArray *middleStepArray = [NSMutableArray array];
    middleStepArray = [self getNextStepInfo:task.assignStep resultArray:middleStepArray];
    [self.stepArray addObjectsFromArray:middleStepArray];
//    if (task.endUser != nil) {
//        [self.stepArray addObject:task.endUser];
//    }
    return self.stepArray;
}
- (NSMutableArray *)getNextStepInfo:(ZHStep *)step resultArray:(NSMutableArray *)result{
    // 添加当前步骤
    [result addObject:step];
    if (step.hasNext.count <= 0) {
        return  result;
    }else{
        for (ZHStep *nextStep in step.hasNext) {
            [self getNextStepInfo:nextStep resultArray:result];
        }
        return result;
    }
}
@end

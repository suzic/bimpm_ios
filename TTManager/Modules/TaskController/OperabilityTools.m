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
        self.type = type;
    }
    return self;
}
//- (void)changCurrentStepArray:(ZHUser *)user to:(BOOL)add{
//    if (add == YES) {
//        [self.stepArray addObject:user];
//    }else{
//        self.finishUser = user;
//    }
//}
//- (void)deleteStepAttayByIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1) {
//        self.finishUser = nil;
//    }else{
//        [self.stepArray removeObjectAtIndex:indexPath.row];
//    }
//}
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
    _task = task;
    self.stepArray = [self getCurrentTaskStep:_task];
}
- (NSMutableArray *)getCurrentTaskStep:(ZHTask *)task{

    NSMutableArray *middleStepArray = [self allObjects:task.belongFlow.stepFirst];
    return middleStepArray;
}
- (NSMutableArray *)allObjects:(ZHStep *)step {
    NSMutableArray *result = [NSMutableArray array];
    [self fillArray:step into:result];
    return result;
}
- (void)fillArray:(ZHStep *)step into:(NSMutableArray *)result {
    [result addObject:step];
    if (step.hasNext.count >1) {
        NSArray *itemArray = [step.hasNext allObjects];
        ZHStep *lastStep = itemArray[0];
        [result addObjectsFromArray:itemArray];
        [result addObject:[lastStep.hasNext allObjects][0]];
    }else{
        for (ZHStep *stepItem in step.hasNext) {
            [self fillArray:stepItem into:result];
        }
    }
}
@end
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
        self.type = type;
        self.isCanEdit = NO;
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
}

#pragma mark - setter and getter

- (void)setCurrentSelectedStep:(ZHStep *)currentSelectedStep{
    _currentSelectedStep = currentSelectedStep;
    [self taskEditStatus:_currentSelectedStep];
}
- (void)setCurrentStep:(ZHStep *)currentStep{
    _currentStep = currentStep;
    [self taskEditStatus:_currentSelectedStep];
}
- (void)setTask:(ZHTask *)task{
    _task = task;
    self.stepArray = [self getCurrentTaskStep:_task];
    [self getCurrentIndex];
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

// 获取当前进行中的任务步骤和下标
- (void)getCurrentIndex{
    
    NSArray *stepCurrent = [_task.belongFlow.stepCurrent allObjects];
    ZHStep *currentStep = nil;
    ZHUser *currentUser = [DataManager defaultInstance].currentUser;

    if ([_task.flow_state intValue] == 2 ) {
        if (_task.assignStep.state == 1) {
            self.currentIndex = 0;
            self.currentStep = self.stepArray[0];
            self.currentSelectedStep = self.stepArray[0];
        }else{
            if (stepCurrent.count == 1) {
                currentStep = stepCurrent[0];
            }
            else{
                for (ZHStep *currentStepItem in stepCurrent) {
                    if (currentStepItem.responseUser.id_user == currentUser.id_user && currentStepItem.state == 2) {
                        currentStep = currentStepItem;
                        break;
                    }
                }
            }
            if (currentStep != nil) {
                for (int i = 0; i< self.stepArray.count; i++) {
                    ZHStep *stepItem = self.stepArray[i];
                    if (stepItem.responseUser.id_user == currentUser.id_user && stepItem.state == 2) {
                        self.currentIndex = i;
                        self.currentSelectedStep = stepItem;
                        self.currentStep = stepItem;
                        break;
                    }
                }
            }
        }
        
    }else{
        self.currentIndex = 0;
        self.currentStep = self.stepArray[0];
        self.currentSelectedStep = self.stepArray[0];
    }
}

- (ZHStep *)getPreviousStep{
    ZHStep *resultStep = nil;
    if (self.currentIndex) {
        resultStep = self.stepArray[self.currentIndex-1];
    }
    return resultStep;
}
- (void)taskEditStatus:(ZHStep *)step{
    if (step.assignTask.belongFlow.state == 2 && step.state == 2 && step.responseUser.id_user == [DataManager defaultInstance].currentUser.id_user) {
        self.isCanEdit = YES;
    }else{
        self.isCanEdit = NO;
    }
    // 未开始也可以编辑
    if (self.task.belongFlow.state == 0) {
        self.isCanEdit = YES;
    }
    NSLog(@"当前是否可编辑 = %d",self.isCanEdit);
}
@end

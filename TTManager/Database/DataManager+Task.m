//
//  DataManager+Task.m
//  TTManager
//
//  Created by chao liu on 2021/1/5.
//

#import "DataManager+Task.h"

@implementation DataManager (Task)

- (ZHTask *)getTaskFromCoredataByID:(int)uid_task{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid_task = %d", uid_task];
    NSArray *result = [self arrayFromCoreData:@"ZHTask" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHTask *task = nil;
    if (result != nil && result.count > 0)
        task = result[0];
    else
    {
        task = (ZHTask *)[self insertIntoCoreData:@"ZHTask"];
        task.uid_task = INT_32_TO_STRING(uid_task);
    }
    return task;
}
- (ZHFlow *)getFlowStepFromCoredataByID:(int)uid_flow{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid_flow = %d", uid_flow];
    NSArray *result = [self arrayFromCoreData:@"ZHFlow" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHFlow *flow = nil;
    if (result != nil && result.count > 0)
        flow = result[0];
    else
    {
        flow = (ZHFlow *)[self insertIntoCoreData:@"ZHFlow"];
        flow.uid_flow = INT_32_TO_STRING(uid_flow);
    }
    return flow;
}
- (ZHStep *)getStepFromCoredataByID:(NSString *)uid_step{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid_step = %@", uid_step];
    NSArray *result = [self arrayFromCoreData:@"ZHStep" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHStep *step = nil;
    if (result != nil && result.count > 0)
        step = result[0];
    else
    {
        step = (ZHStep *)[self insertIntoCoreData:@"ZHStep"];
        step.uid_step = uid_step;
    }
    return step;
}

- (ZHTask *)syncTaskWithTaskInfo:(NSDictionary *)info{
//    // 当前选中的项目
//    ZHProject *currentProject = [self getProjectFromCoredataById:[info[@"fid_project"] intValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    ZHTask *task = [self getTaskFromCoredataByID:[info[@"uid_task"] intValue]];
    [self cleanTaskRelation:task];
    NSLog(@"%@",task.belongFlow.stepFirst);
    task.uid_task = info[@"uid_task"];
    task.fid_project = [info[@"fid_project"] intValue];
    task.uid_task = info[@"uid_task"];

    task.name = info[@"flow_name"];
    task.info = info[@"info"];
    task.memo = info[@"memo"];
//    task.flow_state = info[@"flow_state"];
//    task.flow_name = info[@"flow_name"];
//    task.first_memo = info[@"first_memo"];
    task.priority = [info[@"priority"] intValue];
    if (![SZUtil isEmptyOrNull:info[@"start_date"]]) {
        task.start_date = [dateFormatter dateFromString:info[@"start_date"]];
    }
    if (![SZUtil isEmptyOrNull:info[@"end_date"]]) {
        task.end_date = [dateFormatter dateFromString:info[@"end_date"]];
    }
    if (![SZUtil isEmptyOrNull:info[@"interrupt_date"]]) {
        task.interrupt_date = [dateFormatter dateFromString:info[@"interrupt_date"]];
    }
//    task.end_date = info[@"end_date"];
//    task.interrupt_date = info[@"interrupt_date"];
    task.category = [info[@"category"] intValue];
    task.type = [info[@"type"] intValue];
    
    // startUser
    ZHUser *startUser = nil;
    if (info[@"first_user_info"] != nil) {
        startUser = [self syncTaskUserWithUserInfo:info[@"first_user_info"]];
    }
    //responseUser
    ZHUser *responseUser = nil;
    if (info[@"user_info"] != nil) {
        responseUser = [self syncTaskUserWithUserInfo:info[@"user_info"]];
    }
    //endUser
    ZHUser *endUser = nil;
    if ([info[@"last_user_info"] isKindOfClass:[NSDictionary class]]) {
        endUser = [self syncTaskUserWithUserInfo:info[@"last_user_info"]];
    }
    
    // current_user_info
    if ([info[@"current_user_info"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in info[@"current_user_info"]) {
            ZHUser *current_user_info = [self syncTaskUserWithUserInfo:dic];
            [task addCurrentUsersObject:current_user_info];
        }
    }
    if ([info[@"first_memo_target"] isKindOfClass:[NSArray class]]) {
        //first_memo_target
        for (NSDictionary *target in info[@"first_memo_target"]) {
            ZHTarget *first_memo_target = [self syncTargetWithInfoItem:target];
            task.firstTarget = first_memo_target;
        }
    }
    // flow 默认只有一个
    NSArray *flowArray = info[@"flow"];
    ZHFlow *flow = nil;
    
    if (flowArray.count >0) {
        flow = [self syncFlowWithFlowDic:flowArray[0]];
    }
    ////flow_step
    ZHStep *step = [self syncStep:nil withStepDic:info[@"flow_step"]];
    task.assignStep = step;
    task.startUser = startUser;
    task.responseUser = responseUser;
    task.endUser = endUser;
    task.belongFlow = flow;
    return task;
    
}
// 同步用户信息
- (ZHUser *)syncTaskUserWithUserInfo:(NSDictionary *)userInfo{
    // 获取user
    ZHUser *user = [self getUserFromCoredataByID:[userInfo[@"id_user"] intValue]];
    [self syncUser:user withUserInfo:userInfo];
    return user;
}
// 同步flow
- (ZHFlow *)syncFlowWithFlowDic:(NSDictionary *)flowDic{
    ZHFlow *flow = [self getFlowStepFromCoredataByID:[flowDic[@"uid_flow"] intValue]];
    
    ZHProject *project = [self getProjectFromCoredataById:[flowDic[@"fid_project"] intValue]];
    flow.belongProject = project;
    flow.name = flowDic[@"name"];
    flow.info = flowDic[@"info"];
    flow.dynamic = [flowDic[@"dynamic"] boolValue];
    
    flow.priority = [flowDic[@"priority"] intValue];
    flow.state = [flowDic[@"state"] intValue];
    flow.memo = flowDic[@"memo"];
    //creator_user
    //response_user
    ZHUser *user = [self getUserFromCoredataByID:[flowDic[@"creator_user"][@"id_user"] intValue]];
    flow.createUser = [self syncUser:user withUserInfo:flowDic[@"creator_user"]];
     
    //creator_rule
//    flow.creator_rule = flowDic[@"creator_rule"];
    // first_step    
    flow.stepFirst = [self syncStep:nil withStepDic:flowDic[@"first_step"]];
    //last_step
    flow.stepLast = [self syncStep:nil withStepDic:flowDic[@"last_step"]];
    // current_step
    if ([flowDic[@"current_step"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *stepitem in flowDic[@"current_step"]) {
            ZHStep *step = [self syncStep:nil withStepDic:stepitem];
            [flow addStepCurrentObject:step];
        }
    }
    return flow;
}
// 同步flow_step
- (ZHStep *)syncStep:(ZHStep *)prevsStep withStepDic:(NSDictionary *)stepDic{
    
    ZHStep *step = [self getStepFromCoredataByID:stepDic[@"uid_step"]];
//    [step removeHasNext:step.hasNext];
//    if (step.responseUser != nil) {
//        step.responseUser = nil;
//    }
    // 如果prevsStep上一步存在
    if (prevsStep != nil) {
        [step addHasPrevsObject:prevsStep];
    }
    step.fid_clone_step = stepDic[@"fid_clone_step"];
    step.name = stepDic[@"name"];
    if (![SZUtil isEmptyOrNull:stepDic[@"info"]]) {
        step.info = stepDic[@"info"];
    }
    step.memo_uid_doc_fixed = stepDic[@"memo_target_list_fixed"];
    // 存在覆盖的情况 step_to设置了内容，lastStep覆盖了
    if (![SZUtil isEmptyOrNull:stepDic[@"memo"]]) {
        step.memo = stepDic[@"memo"];
    }
    step.process_type = [stepDic[@"process_type"] intValue];
    step.response_user_fixed = [stepDic[@"response_user_fixed"] boolValue];
    step.decision = [stepDic[@"decision"] intValue];
    step.state = [stepDic[@"state"] intValue];
    
    step.in_waiting = [stepDic[@"in_waiting"] boolValue];
    step.days_waiting = [stepDic[@"days_waiting"] intValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    
    if (![SZUtil isEmptyOrNull:stepDic[@"plan_start"]]) {
        step.plan_start = [dateFormatter dateFromString:stepDic[@"plan_start"]];
    }
    if (![SZUtil isEmptyOrNull:stepDic[@"plan_end"]]) {
        step.plan_end = [dateFormatter dateFromString:stepDic[@"plan_end"]];
    }
    if (![SZUtil isEmptyOrNull:stepDic[@"start_date"]]) {
        step.start_date = [dateFormatter dateFromString:stepDic[@"start_date"]];
    }
    if (![SZUtil isEmptyOrNull:stepDic[@"end_date"]]) {
        step.end_date = [dateFormatter dateFromString:stepDic[@"end_date"]];
    }
    if (![SZUtil isEmptyOrNull:stepDic[@"interrupt_date"]]) {
        step.interrupt_date = [dateFormatter dateFromString:stepDic[@"interrupt_date"]];
    }
    // memo_target_list
    if ([stepDic[@"memo_target_list"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *targetDic in stepDic[@"memo_target_list"]) {
            ZHTarget *target = [self syncTargetWithInfoItem:targetDic];
            [step addMemoDocsObject:target];
        }
    }
    
    //response_user
    if ([stepDic[@"response_user"] isKindOfClass:[NSDictionary class]]) {
        ZHUser *user = [self getUserFromCoredataByID:[stepDic[@"response_user"][@"id_user"] intValue]];
        step.responseUser = [self syncUser:user withUserInfo:stepDic[@"response_user"]];
    }else{
        step.responseUser = nil;
    }
    
    // step_to
    NSArray *step_toArray = stepDic[@"step_to"];
    if ([step_toArray isKindOfClass:[NSArray class]]) {
        if (step_toArray.count >0) {
            for (NSDictionary *stepItemDic in step_toArray) {
                ZHStep *stepItem = [self syncStep:step withStepDic:stepItemDic];
//                if (stepItem.responseUser != nil) {
//                    stepItem.responseUser = nil;
//                }
                [step addHasNextObject:stepItem];
            }
        }
    }
    return step;
}
- (void)cleanTaskRelation:(ZHTask *)task{
    [self deleteFromCoreData:task.assignStep];
    task.assignStep = nil;
    
    for (ZHStep *step in task.belongFlow.stepFirst.hasNext) {
        [self deleteFromCoreData:step];
    }
    [self deleteFromCoreData:task.belongFlow.stepFirst];
    [self deleteFromCoreData:task.belongFlow.stepLast];
    [self deleteFromCoreData:task.belongFlow];
    
    task.belongFlow = nil;
    [self deleteFromCoreData:task.endUser];
    task.endUser = nil;

    [self deleteFromCoreData:task.firstTarget];
    task.firstTarget = nil;

    [self deleteFromCoreData:task.responseUser];
    task.responseUser = nil;

    [self deleteFromCoreData:task.startUser];
    for (ZHUser *user in task.currentUsers) {
        [self deleteFromCoreData:user];
    }
    task.currentUsers = nil;
}

@end

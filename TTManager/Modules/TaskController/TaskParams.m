//
//  TaskParams.m
//  TTManager
//
//  Created by chao liu on 2021/1/9.
//

#import "TaskParams.h"

@interface TaskParams ()

@end

@implementation TaskParams

- (NSDictionary *)getNewTaskParams{
    ZHProject *project = [DataManager defaultInstance].currentProject;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"id_flow_template"] = [NSString stringWithFormat:@"%ld",self.id_flow_template];
    dic[@"task_info"] = @{@"type":@"0",
                          @"fid_project":INT_32_TO_STRING(project.id_project),
    };
    return dic;
}
- (NSMutableDictionary *)getTaskDetailsParams{
    NSDictionary *dic = @{@"uid_task":self.uid_task};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getTaskEditParams{
    NSDictionary *dic = @{@"uid_task":self.uid_task,
                          @"name":self.name,
                          @"info":self.info};
    return [NSMutableDictionary dictionaryWithDictionary:@{@"task_info":dic}];
}
- (NSMutableDictionary *)getMemoParams{
    NSDictionary *dic = @{@"id_task":self.uid_task,
                          @"code":@"MEMO",
                          @"param":@"",
                          @"info":self.memo};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getTaskPriorityParams{
    NSDictionary *dic = @{@"id_task":self.uid_task,
                          @"code":@"PRIORITY",
                          @"param":@(self.priority),
                          @"info":@""};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getTaskDatePlanParams{
    NSTimeInterval timeInterval = [self.planDate timeIntervalSince1970];
    NSDictionary *dic = @{@"id_task":self.uid_task,
                          @"code":@"DATEPLAN",
                          @"param":@"1",
                          @"info":[NSString stringWithFormat:@"%ld",(long)timeInterval]};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getTaskFileParams{
    NSDictionary *dic = @{@"id_task":self.uid_task,
                          @"code":@"FILE",
                          @"param":@"2",
                          @"info":@"uid_target"};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
// 指派一个目标人
- (NSMutableDictionary *)getToUserParams:(BOOL)to{
    NSDictionary *dic = @{@"id_task":self.uid_task,
                          @"code":@"TO",
                          @"param":to == YES ?@"1":@"0",
                          @"info":self.id_user};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getAssignUserParams{
    NSDictionary *dic = @{@"id_task":self.uid_task,
                          @"code":@"ASSIGN",
                          @"param":self.uid_step,
                          @"info":self.id_user};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getProcessSubmitParams{
    NSDictionary *dic = @{@"task_list":@[self.uid_task],
                          @"code":@"SUBMIT",
                          @"param":@"1",
                          @"info":@""};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getProcessRecallParams{
    NSDictionary *dic = @{@"task_list":@[self.uid_task],
                          @"code":@"RECALL",
                          @"param":@"",
                          @"info":@""};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getProcessTerminateParams{
    NSDictionary *dic = @{@"task_list":@[self.uid_task],
                          @"code":@"TERMINATE",
                          @"param":@"",
                          @"info":@""};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}

@end

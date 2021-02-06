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
    ZHProject *project = [DataManager defaultInstance].currentProject;
    NSDictionary *dic = @{@"uid_task":self.uid_task,
                          @"fid_project":INT_32_TO_STRING(project.id_project),
                          @"user_info":[self getUserInfo],
                          @"name":self.name,
                          @"category":@"1",
                          @"type":@"0",
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
    NSTimeInterval timeInterval = [self.planDate timeIntervalSince1970]*1000;
    NSDictionary *dic = @{@"id_task":self.uid_task,
                          @"code":@"DATEPLAN",
                          @"param":@"1",
                          @"info":[NSString stringWithFormat:@"%ld",(long)timeInterval]};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getTaskFileParams:(BOOL)add{
    NSDictionary *dic = @{@"id_task":self.uid_task,
                          @"code":@"FILE",
                          @"param":add == YES ?@"1":@"0",
                          @"info":self.uid_target};
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
                          @"param":self.submitParams,
                          @"info":@""};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getProcessRecallParams{
    NSDictionary *dic = @{@"task_list":@[self.uid_task],
                          @"code":@"RECALL",
                          @"param":@"",
                          @"info":self.memo};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSMutableDictionary *)getProcessTerminateParams{
    NSDictionary *dic = @{@"task_list":@[self.uid_task],
                          @"code":@"TERMINATE",
                          @"param":@"1",
                          @"info":self.memo};
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (NSDictionary *)getUserInfo{
    ZHUser *user = [DataManager defaultInstance].currentUser;
    NSDictionary *dic = @{@"id_user":INT_32_TO_STRING(user.id_user),
                          @"phone":user.phone,
                          @"name":user.name,
                          @"avatar":user.avatar,
                          @"gender":INT_32_TO_STRING(user.gender),
                          @"signature":user.signature == nil ? @"":user.signature};
    return dic;
}
@end

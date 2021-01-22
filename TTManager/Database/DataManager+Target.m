//
//  DataManager+Target.m
//  TTManager
//
//  Created by chao liu on 2021/1/4.
//

#import "DataManager+Target.h"

@implementation DataManager (Target)
- (ZHTarget *)getTargetFromCoreDataById:(NSString *)uid_target{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid_target = %d", uid_target];
    NSArray *result = [self arrayFromCoreData:@"ZHTarget" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHTarget *target = nil;
    if (result != nil && result.count > 0)
        target = result[0];
    else
    {
        target = (ZHTarget *)[self insertIntoCoreData:@"ZHTarget"];
        target.uid_target = uid_target;
    }
    return target;
}
- (NSMutableArray *)syncTargetWithInfo:(NSDictionary *)dic{
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSDictionary *targetDic in dic[@"list"]) {
        ZHTarget *childrenTarget = [self syncTargetWithInfoItem:targetDic];
        [result addObject:childrenTarget];
    }
    return result;
}
- (ZHTarget *)syncTargetWithInfoItem:(NSDictionary *)targetItem{
    ZHProject *project = [self getProjectFromCoredataById:[targetItem[@"fid_project"] intValue]];
    ZHTarget *childrenTarget = [self getTargetFromCoreDataById:targetItem[@"uid_target"]];
    childrenTarget.uid_target = targetItem[@"uid_target"];
    childrenTarget.fid_parent = targetItem[@"fid_parent"];
    childrenTarget.fid_project = [NSString stringWithFormat:@"%@",targetItem[@"fid_project"]];
    childrenTarget.id_module = [targetItem[@"id_module"] intValue];
    childrenTarget.is_file = [targetItem[@"is_file"] boolValue];
    childrenTarget.access_mode = [targetItem[@"access_mode"] intValue];
//        childrenTarget.record_status = [targetDic[@"record_status"] intValue];
    childrenTarget.name = targetItem[@"name"];
    childrenTarget.password = targetItem[@"password"];
    childrenTarget.size = [targetItem[@"size"] intValue];
    childrenTarget.history_size = [targetItem[@"history_size"] intValue];
    childrenTarget.type = [targetItem[@"type"] intValue];
    childrenTarget.multi_editable = [targetItem[@"multi_editable"] intValue];
    childrenTarget.link = targetItem[@"link"];
    childrenTarget.check_sum = [targetItem[@"check_sum"] intValue];
    childrenTarget.version = [targetItem[@"version"] intValue];
    
    childrenTarget.sub_folder_count = [targetItem[@"sub_folder_count"] intValue];
    childrenTarget.sub_file_count = [targetItem[@"sub_file_count"] intValue];

    // 父id存在的时候查找
    if (![SZUtil isEmptyOrNull:targetItem[@"fid_parent"]]) {
        ZHTarget *parentTarget = [self getTargetFromCoreDataById:targetItem[@"fid_parent"]];
        childrenTarget.parentTarget = parentTarget;
    }
    
    // owner
    if ([targetItem[@"owner"] isKindOfClass:[NSDictionary class]]) {
        ZHUser *user = [self getUserFromCoredataByID:[targetItem[@"owner"][@"id_user"] intValue]];
        user = [self syncUser:user withUserInfo:targetItem[@"owner"]];
        childrenTarget.owner = user;
    }
    
    [self cleanCurrentTargetAllows:childrenTarget];
    
    // allow
    if ([targetItem[@"allows"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *allowDic in targetItem[@"allows"]) {
            ZHAllow *allow = (ZHAllow *)[self insertIntoCoreData:@"ZHAllow"];
            allow = [self syncAllow:allow withAllowInfo:allowDic];
            allow.belongTarget = childrenTarget;
        }
    }
    
    childrenTarget.belongProject = project;
    return childrenTarget;
}
- (void)cleanCurrentTargetAllows:(ZHTarget *)target{
    for (ZHAllow *allow in target.hasAllows) {
        [self deleteFromCoreData:allow];
    }
}
- (ZHAllow *)syncAllow:(ZHAllow *)allow withAllowInfo:(NSDictionary *)allowDic{
    allow.uid_target = allowDic[@"uid_target"];
    allow.allow_level = [allowDic[@"allow_level"] intValue];
    if ([allowDic[@"user"] isKindOfClass:[NSDictionary class]]) {
        ZHUser *user = [self getUserFromCoredataByID:[allowDic[@"user"][@"id_user"] intValue]];
        user = [self syncUser:user withUserInfo:allowDic[@"user"]];
        allow.belongUser = user;
    }
    return allow;
}
@end

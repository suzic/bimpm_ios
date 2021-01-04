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
        
        ZHProject *project = [self getProjectFromCoredataById:[targetDic[@"fid_project"] intValue]];
        ZHTarget *childrenTarget = [self getTargetFromCoreDataById:targetDic[@"uid_target"]];
        childrenTarget.uid_target = targetDic[@"uid_target"];
        childrenTarget.fid_parent = targetDic[@"fid_parent"];
        childrenTarget.fid_project = targetDic[@"fid_project"];
        childrenTarget.id_module = [targetDic[@"id_module"] intValue];
        childrenTarget.is_file = [targetDic[@"is_file"] boolValue];
        childrenTarget.access_mode = [targetDic[@"access_mode"] intValue];
//        childrenTarget.record_status = [targetDic[@"record_status"] intValue];
        childrenTarget.name = targetDic[@"name"];
        childrenTarget.password = targetDic[@"password"];
        childrenTarget.size = [targetDic[@"size"] intValue];
        childrenTarget.history_size = [targetDic[@"history_size"] intValue];
        childrenTarget.type = [targetDic[@"type"] intValue];
        childrenTarget.multi_editable = [targetDic[@"multi_editable"] intValue];
        childrenTarget.link = targetDic[@"link"];
        childrenTarget.check_sum = [targetDic[@"check_sum"] intValue];
        childrenTarget.version = [targetDic[@"version"] intValue];
        
        childrenTarget.sub_folder_count = [targetDic[@"sub_folder_count"] intValue];
        childrenTarget.sub_file_count = [targetDic[@"sub_file_count"] intValue];

        // 父id存在的时候查找
        if (![SZUtil isEmptyOrNull:dic[@"fid_parent"]]) {
            ZHTarget *parentTarget = [self getTargetFromCoreDataById:targetDic[@"fid_parent"]];
            childrenTarget.parentTarget = parentTarget;
        }
        childrenTarget.belongProject = project;
        [result addObject:childrenTarget];
    }
    return result;
}
@end

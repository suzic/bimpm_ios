//
//  ClockInManager.m
//  TTManager
//
//  Created by chao liu on 2021/10/13.
//

#import "ClockInManager.h"

// 打卡的key
static NSString *clockInList = @"clockInList";
// INT_32_TO_STRING(project.id_project)
@implementation ClockInManager
- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self initGoWork];
    }
    return self;
}

// 初始化上班打卡信息
- (void)initGoWork{
    // 获取当前时间
    NSString *curTime = [SZUtil getDateString:[NSDate date]];
    NSDictionary *list = [[NSUserDefaults standardUserDefaults] objectForKey:clockInList];
    // 不存在则证明从来没打过卡
    if (list == nil || [list isKindOfClass:[NSNull class]] || [list isEqual:[NSNull null]]) {
        self.isWork = NO;
    }else{
        ZHProject *project = [DataManager defaultInstance].currentProject;
        NSString *curProjectId = INT_32_TO_STRING(project.id_project);
        // 当前项目的打卡记录
        NSDictionary *projectWork = list[curProjectId];
        if (projectWork == nil || [projectWork isKindOfClass:[NSNull class]] || [projectWork isEqual:[NSNull null]]) {
            self.isWork = NO;
        }else{
            NSString *work = projectWork[curTime];
            // 为空今天没打卡
            if ([SZUtil isEmptyOrNull:work]) {
                self.isWork = NO;
            }
            else{
                // 1为今天打过上班的卡
                if ([work isEqualToString:@"1"]) {
                    self.isWork = YES;
                }else{
                    self.isWork = NO;
                }
            }
        }
    }
}

// 上班打卡成功
- (void)goWorkClockInSuccess{
    self.isWork = YES;
    // 获取当前时间
    NSString *curTime = [SZUtil getDateString:[NSDate date]];
    ZHProject *project = [DataManager defaultInstance].currentProject;
    NSString *curProjectId = INT_32_TO_STRING(project.id_project);
    NSDictionary *dict = @{curProjectId:@{curTime:@"1"}};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:clockInList];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

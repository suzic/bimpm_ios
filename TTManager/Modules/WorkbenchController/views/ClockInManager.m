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
    NSString *curTime = [SZUtil getTimeNow];
    ZHProject *project = [DataManager defaultInstance].currentProject;
    NSString *curProjectId = INT_32_TO_STRING(project.id_project);
    NSDictionary *dict = @{curProjectId:@{curTime:@"1"}};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:clockInList];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSInteger)getClockInType{
    NSInteger type = NSNotFound;
    ZHProject *project = [DataManager defaultInstance].currentProject;
    NSString *check_in = [NSString stringWithFormat:@"%lld",project.time_check_in];
    if ([SZUtil isEmptyOrNull:check_in] || [check_in isEqualToString:@"0"]){
        check_in = @"09:00:00";
    }else{
        self.time_check_in = [SZUtil getTimeLengthString:project.time_check_in];
    }
    check_in = [NSString stringWithFormat:@"%@ %@",[SZUtil getDateString:[NSDate date]],check_in];
    
    NSString *nowDate = [SZUtil getTimeNow];
    NSDate *date = [SZUtil getTimeDate:nowDate];

    NSDate *clockinData = [SZUtil getTimeDate:check_in];
    
    NSComparisonResult result = [date compare:clockinData];
    if (result == NSOrderedDescending) {
        type = 1;
    }else{
        type = 0;
    }
    return type;
}
- (void)setWorkTime{
    ZHProject *project = [DataManager defaultInstance].currentProject;
    NSString *check_in = [NSString stringWithFormat:@"%lld",project.time_check_in];
    if ([SZUtil isEmptyOrNull:check_in] || [check_in isEqualToString:@"0"]){
        self.time_check_in = @"上班请在09:00之前打卡";
    }else{
        self.time_check_in = [NSString stringWithFormat:@"上班请在%@之前打卡",[SZUtil getTimeLengthString:project.time_check_in]];
    }
    
    NSString *check_out = [NSString stringWithFormat:@"%lld",project.time_check_out];
    if ([SZUtil isEmptyOrNull:check_out] ||[check_out isEqualToString:@"0"]){
        self.time_check_out = @"下班请在18:00之后打卡";
    }else{
        self.time_check_out = [NSString stringWithFormat:@"下班请在%@之后打卡",[SZUtil getTimeLengthString:project.time_check_out]];
    }
}
- (NSInteger)clockInStatusType:(NSInteger)type{
    NSInteger resultType = NSNotFound;
    ZHProject *project = [DataManager defaultInstance].currentProject;
    NSString *clockTime = [NSString stringWithFormat:@"%lld",type == 0 ?project.time_check_in:project.time_check_out];
    
    if ([SZUtil isEmptyOrNull:clockTime] || [clockTime isEqualToString:@"0"]){
        clockTime = type == 0 ? @"09:00:00" :@"18:00:00";
    }else{
        clockTime = [SZUtil getTimeLengthString:type == 0 ?project.time_check_in:project.time_check_out];
    }
    clockTime = [NSString stringWithFormat:@"%@ %@",[SZUtil getDateString:[NSDate date]],clockTime];
    
    NSString *nowDate = [SZUtil getTimeNow];
    NSDate *date = [SZUtil getTimeDate:nowDate];

    NSDate *clockinData = [SZUtil getTimeDate:clockTime];
    
    NSComparisonResult result = [date compare:clockinData];
    
    if (result == NSOrderedDescending) {
        if (type == 0) {
            resultType = 2;
        }else if(type == 1){
            resultType = 1;
        }
        
    }else if(result == NSOrderedAscending){
        if (type == 0) {
            resultType = 1;
        }else if(type == 1){
            resultType = 2;
        }
    }else{
        resultType = 1;
    }
    return  resultType;
}
@end

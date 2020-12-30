//
//  ZHTask+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHTask+CoreDataProperties.h"

@implementation ZHTask (CoreDataProperties)

+ (NSFetchRequest<ZHTask *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHTask"];
}

@dynamic category;
@dynamic end_date;
@dynamic fid_project;
@dynamic fid_step;
@dynamic fid_user;
@dynamic info;
@dynamic interrupt_date;
@dynamic memo;
@dynamic name;
@dynamic priority;
@dynamic start_date;
@dynamic type;
@dynamic uid_task;
@dynamic assignStep;
@dynamic belongFlow;
@dynamic currentUsers;
@dynamic endUser;
@dynamic firstTarget;
@dynamic inMessages;
@dynamic responseUser;
@dynamic startUser;

@end

//
//  ZHTask+CoreDataProperties.m
//  TTManager
//
//  Created by chao liu on 2021/2/14.
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
@dynamic flow_name;
@dynamic flow_state;
@dynamic assignStep;
@dynamic belongFlow;
@dynamic currentUsers;
@dynamic endUser;
@dynamic firstTarget;
@dynamic inMessages;
@dynamic responseUser;
@dynamic startUser;

@end

//
//  ZHUserProject+CoreDataProperties.m
//  TTManager
//
//  Created by chao liu on 2021/1/6.
//
//

#import "ZHUserProject+CoreDataProperties.h"

@implementation ZHUserProject (CoreDataProperties)

+ (NSFetchRequest<ZHUserProject *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHUserProject"];
}

@dynamic enable;
@dynamic enter_date;
@dynamic id_user_project;
@dynamic in_apply;
@dynamic in_invite;
@dynamic in_manager_invite;
@dynamic info;
@dynamic invite_user;
@dynamic is_default;
@dynamic order_index;
@dynamic user_task_count;
@dynamic assignRole;
@dynamic belongProject;
@dynamic belongUser;
@dynamic inDepartments;

@end

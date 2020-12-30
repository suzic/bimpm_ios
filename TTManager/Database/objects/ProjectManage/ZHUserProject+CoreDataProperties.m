//
//  ZHUserProject+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
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
@dynamic inDepartments;
@dynamic assignRole;
@dynamic belongProject;
@dynamic belongUser;

@end

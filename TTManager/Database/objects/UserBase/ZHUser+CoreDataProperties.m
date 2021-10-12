//
//  ZHUser+CoreDataProperties.m
//  TTManager
//
//  Created by chao liu on 2021/10/12.
//
//

#import "ZHUser+CoreDataProperties.h"

@implementation ZHUser (CoreDataProperties)

+ (NSFetchRequest<ZHUser *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHUser"];
}

@dynamic avatar;
@dynamic captcha_code;
@dynamic current_project;
@dynamic device;
@dynamic email;
@dynamic gender;
@dynamic id_user;
@dynamic is_login;
@dynamic lock_password;
@dynamic name;
@dynamic pass_md5;
@dynamic password;
@dynamic phone;
@dynamic signature;
@dynamic status;
@dynamic token;
@dynamic uid_chat;
@dynamic verify_code;
@dynamic wechat_num;
@dynamic asFlowCreator;
@dynamic asFormEditor;
@dynamic asReceiver;
@dynamic asSender;
@dynamic asTaskCurrent;
@dynamic asTaskEnder;
@dynamic asTaskStarter;
@dynamic hasAllows;
@dynamic hasProjects;
@dynamic hasSteps;
@dynamic hasTasks;
@dynamic ownTargets;
@dynamic hasMemo;

@end

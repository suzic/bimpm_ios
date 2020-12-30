//
//  ZHForm+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHForm+CoreDataProperties.h"

@implementation ZHForm (CoreDataProperties)

+ (NSFetchRequest<ZHForm *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHForm"];
}

@dynamic buddy_file;
@dynamic instance_ident;
@dynamic instance_name;
@dynamic instance_set;
@dynamic key_pattern;
@dynamic name;
@dynamic uid_form;
@dynamic uid_ident;
@dynamic unique_check;
@dynamic update_date;
@dynamic update_user;
@dynamic url_alarm;
@dynamic url_info;
@dynamic belongProject;
@dynamic buddyFile;
@dynamic hasItems;
@dynamic lastEditor;

@end

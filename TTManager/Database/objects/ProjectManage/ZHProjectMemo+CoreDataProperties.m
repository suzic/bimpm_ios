//
//  ZHProjectMemo+CoreDataProperties.m
//  TTManager
//
//  Created by chao liu on 2021/10/12.
//
//

#import "ZHProjectMemo+CoreDataProperties.h"

@implementation ZHProjectMemo (CoreDataProperties)

+ (NSFetchRequest<ZHProjectMemo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHProjectMemo"];
}

@dynamic check;
@dynamic edit_date;
@dynamic fid_project;
@dynamic line;
@dynamic order_index;
@dynamic page_index;
@dynamic assignProject;
@dynamic last_user;

@end

//
//  ZHProjectMemo+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
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

@end

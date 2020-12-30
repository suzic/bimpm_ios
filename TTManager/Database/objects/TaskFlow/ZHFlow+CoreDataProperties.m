//
//  ZHFlow+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHFlow+CoreDataProperties.h"

@implementation ZHFlow (CoreDataProperties)

+ (NSFetchRequest<ZHFlow *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHFlow"];
}

@dynamic dynamic;
@dynamic info;
@dynamic memo;
@dynamic name;
@dynamic priority;
@dynamic state;
@dynamic uid_flow;
@dynamic belongProject;
@dynamic createUser;
@dynamic hasTasks;
@dynamic stepCurrent;
@dynamic stepFirst;
@dynamic stepLast;

@end

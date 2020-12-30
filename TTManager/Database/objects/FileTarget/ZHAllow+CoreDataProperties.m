//
//  ZHAllow+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHAllow+CoreDataProperties.h"

@implementation ZHAllow (CoreDataProperties)

+ (NSFetchRequest<ZHAllow *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHAllow"];
}

@dynamic allow_level;
@dynamic uid_target;
@dynamic belongTarget;
@dynamic belongUser;

@end

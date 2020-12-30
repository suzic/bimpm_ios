//
//  ZHMessage+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHMessage+CoreDataProperties.h"

@implementation ZHMessage (CoreDataProperties)

+ (NSFetchRequest<ZHMessage *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHMessage"];
}

@dynamic content;
@dynamic is_read;
@dynamic read_date;
@dynamic send_date;
@dynamic title;
@dynamic uid_message;
@dynamic assignTarget;
@dynamic assignTask;
@dynamic inProject;
@dynamic receiver;
@dynamic sender;

@end

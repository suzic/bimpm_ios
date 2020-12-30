//
//  ZHStep+CoreDataProperties.m
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHStep+CoreDataProperties.h"

@implementation ZHStep (CoreDataProperties)

+ (NSFetchRequest<ZHStep *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHStep"];
}

@dynamic days_waiting;
@dynamic decision;
@dynamic end_date;
@dynamic fid_clone_step;
@dynamic in_waiting;
@dynamic info;
@dynamic interrupt_date;
@dynamic memo;
@dynamic memo_uid_doc_fixed;
@dynamic name;
@dynamic plan_end;
@dynamic plan_start;
@dynamic process_type;
@dynamic response_user_fixed;
@dynamic start_date;
@dynamic state;
@dynamic uid_step;
@dynamic asCurrent;
@dynamic asFirst;
@dynamic asLast;
@dynamic assignTask;
@dynamic hasNext;
@dynamic hasPrevs;
@dynamic memoDocs;
@dynamic responseUser;

@end

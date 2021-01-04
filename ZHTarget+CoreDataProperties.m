//
//  ZHTarget+CoreDataProperties.m
//  TTManager
//
//  Created by chao liu on 2021/1/4.
//
//

#import "ZHTarget+CoreDataProperties.h"

@implementation ZHTarget (CoreDataProperties)

+ (NSFetchRequest<ZHTarget *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ZHTarget"];
}

@dynamic access_mode;
@dynamic check_sum;
@dynamic fid_parent;
@dynamic history_size;
@dynamic id_module;
@dynamic is_file;
@dynamic link;
@dynamic multi_editable;
@dynamic name;
@dynamic pass_md5;
@dynamic password;
@dynamic size;
@dynamic sub_file_count;
@dynamic sub_folder_count;
@dynamic tag;
@dynamic type;
@dynamic uid_target;
@dynamic version;
@dynamic fid_project;
@dynamic asFormBuddy;
@dynamic asTaskFirst;
@dynamic belongProject;
@dynamic hasAllows;
@dynamic inMessages;
@dynamic inSteps;
@dynamic owner;
@dynamic childrenTarget;
@dynamic parentTarget;

@end

//
//  ZHProjectMemo+CoreDataProperties.h
//  TTManager
//
//  Created by chao liu on 2021/10/12.
//
//

#import "ZHProjectMemo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHProjectMemo (CoreDataProperties)

+ (NSFetchRequest<ZHProjectMemo *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) BOOL check;
@property (nullable, nonatomic, copy) NSDate *edit_date;
@property (nonatomic) int32_t fid_project;
@property (nullable, nonatomic, copy) NSString *line;
@property (nonatomic) int32_t order_index;
@property (nonatomic) int32_t page_index;
@property (nullable, nonatomic, retain) ZHProject *assignProject;
@property (nullable, nonatomic, retain) ZHUser *last_user;

@end

NS_ASSUME_NONNULL_END

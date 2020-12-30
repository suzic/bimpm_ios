//
//  ZHProjectMemo+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHProjectMemo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHProjectMemo (CoreDataProperties)

+ (NSFetchRequest<ZHProjectMemo *> *)fetchRequest;

@property (nonatomic) BOOL check;
@property (nullable, nonatomic, copy) NSDate *edit_date;
@property (nonatomic) int32_t fid_project;
@property (nullable, nonatomic, copy) NSString *line;
@property (nonatomic) int32_t order_index;
@property (nonatomic) int32_t page_index;
@property (nullable, nonatomic, retain) ZHProject *assignProject;

@end

NS_ASSUME_NONNULL_END

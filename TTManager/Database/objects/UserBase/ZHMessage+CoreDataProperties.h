//
//  ZHMessage+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHMessage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHMessage (CoreDataProperties)

+ (NSFetchRequest<ZHMessage *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nonatomic) BOOL is_read;
@property (nullable, nonatomic, copy) NSDate *read_date;
@property (nullable, nonatomic, copy) NSDate *send_date;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *uid_message;
@property (nullable, nonatomic, retain) ZHTarget *assignTarget;
@property (nullable, nonatomic, retain) ZHTask *assignTask;
@property (nullable, nonatomic, retain) ZHProject *inProject;
@property (nullable, nonatomic, retain) ZHUser *receiver;
@property (nullable, nonatomic, retain) ZHUser *sender;

@end

NS_ASSUME_NONNULL_END

//
//  ZHModule+CoreDataProperties.h
//  
//
//  Created by 苏智 on 2020/12/21.
//
//

#import "ZHModule+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHModule (CoreDataProperties)

+ (NSFetchRequest<ZHModule *> *)fetchRequest;

@property (nonatomic) int32_t id_module;
@property (nonatomic) int32_t is_public;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) BOOL online;
@property (nullable, nonatomic, copy) NSString *operation;
@property (nonatomic) int32_t order_index;
@property (nullable, nonatomic, copy) NSString *route;
@property (nullable, nonatomic, retain) ZHRole *belongRoles;

@end

NS_ASSUME_NONNULL_END

//
//  ZHUser+CoreDataClass.h
//  
//
//  Created by 苏智 on 2020/1/19.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZHUserProject, ZHTask, ZHStep, ZHFlow, ZHFormItem, ZHForm, ZHMessage, ZHAllow, ZHTarget,ZHProjectMemo;

NS_ASSUME_NONNULL_BEGIN

@interface ZHUser : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "ZHUser+CoreDataProperties.h"

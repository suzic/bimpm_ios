//
//  UIAlertAction+Extend.m
//  TTManager
//
//  Created by chao liu on 2021/1/9.
//

#import "UIAlertAction+Extend.h"

@implementation UIAlertAction (Extend)

- (void)setTaskType:(TaskType)taskType{
    objc_setAssociatedObject(self, @"taskType", @(taskType), OBJC_ASSOCIATION_RETAIN);
}

- (TaskType)taskType{
    return [objc_getAssociatedObject(self, @"taskType") integerValue];
}

@end

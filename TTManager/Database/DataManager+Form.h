//
//  DataManager+Form.h
//  TTManager
//
//  Created by chao liu on 2021/1/19.
//

#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager (Form)

- (ZHForm *)getFormByFormId:(NSString *)uid_form;
- (ZHFormItem *)getFormItemByFormItemId:(NSString *)uid_item;
- (void)cleanCurrentProjectHasForm:(ZHProject *)project;
- (void)cleanCurrentFormHasFormItem:(ZHForm *)form;

- (ZHForm *)syncFormWithFormInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END

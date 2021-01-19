//
//  DataManager+Form.m
//  TTManager
//
//  Created by chao liu on 2021/1/19.
//

#import "DataManager+Form.h"

@implementation DataManager (Form)

- (ZHForm *)syncFormWithFormInfo:(NSDictionary *)info{
    ZHProject *project = [[DataManager defaultInstance] getProjectFromCoredataById:[info[@"fid_project"] intValue]];
    [[DataManager defaultInstance] cleanCurrentProjectHasForm:project];
    ZHForm *form = [[DataManager defaultInstance] getFormByFormId:[info[@"uid_form"] intValue]];
    [[DataManager defaultInstance] cleanCurrentFormHasFormItem:form];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
//    form.buddyFile =
    form.uid_ident = info[@"uid_ident"];
    form.name = info[@"name"];
    form.unique_check = info[@"unique_check"];
    form.key_pattern = info[@"key_pattern"];
    form.url_info = info[@"url_info"];
    form.url_alarm = info[@"url_alarm"];
    form.update_user = info[@"update_user"];
    if (![SZUtil isEmptyOrNull:info[@"update_date"]]) {
        form.update_date = [dateFormatter dateFromString:info[@"update_date"]];
    }
    form.instance_ident = info[@"instance_ident"];
    form.instance_name = info[@"instance_name"];
    // buddy_file
    if ([info[@"buddy_file"] isKindOfClass:[NSDictionary class]]) {
        ZHTarget *target = [self syncTargetWithInfoItem:info[@"buddy_file"]];
        form.buddyFile = target;
    }
    // last_editor
    if ([info[@"last_editor"] isKindOfClass:[NSDictionary class]]) {
        ZHUser *user = [self getUserFromCoredataByID:[info[@"last_editor"][@"id_user"] intValue]];
        user = [self syncUser:user withUserInfo:info[@"last_editor"]];
        form.lastEditor = user;
    }
    // items
    if ([info[@"items"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *formItem in info[@"items"]) {
            ZHFormItem *item = [self syncFormItemWithFormItemInfo:formItem];
            item.belongForm = form;
        }
    }
    form.belongProject = project;
    return form;
}
- (ZHFormItem *)syncFormItemWithFormItemInfo:(NSDictionary *)info{
    ZHFormItem *item = [self getFormItemByFormItemId:[info[@"uid_item"] intValue]];
    item.ident = info[@"ident"];
    item.order_index = [info[@"order_index"] intValue];
    item.name = info[@"name"];
    item.d_name = info[@"d_name"];
//    item.unit_char = info[@"unit_char"];
    item.type = info[@"type"];
    item.length_min = [info[@"length_min"] intValue];
    item.length_max = [info[@"length_max"] intValue];
    item.not_null = [info[@"not_null"] boolValue];
    item.unique = [info[@"unique"] boolValue];
    item.enum_pool = info[@"enum_pool"];
    item.instance_value = info[@"instance_value"];
    return item;
}
- (ZHForm *)getFormByFormId:(int)uid_form{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid_form = %d", uid_form];
    NSArray *result = [self arrayFromCoreData:@"ZHForm" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHForm *form = nil;
    if (result != nil && result.count > 0)
        form = result[0];
    else
    {
        form = (ZHForm *)[self insertIntoCoreData:@"ZHForm"];
        form.uid_form = INT_32_TO_STRING(uid_form);
    }
    return form;
}
- (ZHFormItem *)getFormItemByFormItemId:(int)uid_item{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid_item = %d", uid_item];
    NSArray *result = [self arrayFromCoreData:@"ZHFormItem" predicate:predicate limit:1 offset:0 orderBy:nil];
    ZHFormItem *formItem = nil;
    if (result != nil && result.count > 0)
        formItem = result[0];
    else
    {
        formItem = (ZHFormItem *)[self insertIntoCoreData:@"ZHFormItem"];
        formItem.uid_item = INT_32_TO_STRING(uid_item);
    }
    return formItem;
}
- (void)cleanCurrentProjectHasForm:(ZHProject *)project{
    for (ZHForm *form in project.hasForms) {
        [self deleteFromCoreData:form];
    }
}
- (void)cleanCurrentFormHasFormItem:(ZHForm *)form{
    for (ZHFormItem *formItem in form.hasItems) {
        [self deleteFromCoreData:formItem];
    }
}
@end

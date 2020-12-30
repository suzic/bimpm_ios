//
//  DataManager+Item.m
//  ttmanager
//
//  Created by 苏智 on 2019/1/17.
//  Copyright © 2019 Suzic. All rights reserved.
//

#import "DataManager+Item.h"

@implementation DataManager (Item)

- (SXItemPool *)getItemPoolFromCoredataById:(int)itemPoolId belongOrganizationId:(int)organizationId
{
    SXOrganization *organization = [self getOrganizationFromCoredataById:organizationId];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"item_pool_id = %d", itemPoolId];
    NSArray *result = [self arrayFromCoreData:@"SXItemPool" predicate:predicate limit:1 offset:0 orderBy:nil];
    SXItemPool *itempool = nil;
    if (result != nil && result.count > 0)
    {
        itempool = result[0];
    }
    else
    {
        itempool = (SXItemPool *)[self insertIntoCoreData:@"SXItemPool"];
        itempool.item_pool_id = itemPoolId;
    }
    itempool.organization_id = organization.organization_id;
    itempool.belong_organziation = organization;
    
    return itempool;
}

- (SXItem *)getItemFromCoredataById:(NSString *)itemId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"item_id = %@", itemId];
    NSArray *result = [self arrayFromCoreData:@"SXItem" predicate:predicate limit:1 offset:0 orderBy:nil];
    SXItem *item = nil;
    if (result != nil && result.count > 0)
        item = result[0];
    else
    {
        item = (SXItem *)[self insertIntoCoreData:@"SXItem"];
        item.item_id = itemId;
    }
    return item;
}

- (void)syncItem:(SXItem *)item withItemInfo:(NSDictionary *)dicData
{
    if (item == nil || dicData == nil)
        return;
    
    item.item_id = dicData[@"id_item"];
    item.item_snapshot_id = dicData[@"id_item_snapshot"];
    item.item_pool_id = [dicData[@"fid_item_pool"] intValue];
    item.organization_id = [dicData[@"fid_organization"] intValue];
    if (item.item_pool_id != 0 && item.organization_id != 0)
    {
        SXItemPool *pool = [self getItemPoolFromCoredataById:item.item_pool_id belongOrganizationId:item.organization_id];
        item.belong_pool = pool;
    }
    item.category_id = [dicData[@"id_category"] intValue];
    item.item_template_id = [dicData[@"fid_item_template"] intValue];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![SZUtil isEmptyOrNull:dicData[@"generate_date"]])
        item.generate_date = [dateFormatter dateFromString:dicData[@"generate_date"]];

    item.sku = dicData[@"sku"];
    item.spu = dicData[@"spu"];
    item.init_price = [dicData[@"init_price"] doubleValue];
    item.shop_state = [dicData[@"shop_state"] boolValue];

    item.name = dicData[@"name"];
    item.pic = dicData[@"pic"];
    item.item_desc = dicData[@"description"];
    
    item.price = [dicData[@"price"] doubleValue];
    item.suggest_location = [dicData[@"suggest_location"] intValue];

    if (dicData[@"generate_user"] != nil)
        item.generate_user = [dicData[@"generate_user"] stringValue];
    if (dicData[@"validate"] != nil)
        item.validate = [dicData[@"validate"] intValue];
}

@end

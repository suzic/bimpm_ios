//
//  DataManager+Bill.m
//  ttmanager
//
//  Created by 苏智 on 2019/1/17.
//  Copyright © 2019 Suzic. All rights reserved.
//

#import "DataManager+Bill.h"

@implementation DataManager (Bill)

- (SXShipment *)getShipmentFromCoredataById:(NSString *)shipmentId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bill_shipment_id = %@", shipmentId];
    NSArray *result = [self arrayFromCoreData:@"SXShipment" predicate:predicate limit:1 offset:0 orderBy:nil];
    SXShipment *shipment = nil;
    if (result != nil && result.count > 0)
        shipment = result[0];
    else
    {
        shipment = (SXShipment *)[self insertIntoCoreData:@"SXShipment"];
        shipment.bill_shipment_id = shipmentId;
    }
    return shipment;
}

- (void)syncShipment:(SXShipment *)shipment withShipmentInfo:(NSDictionary *)dicData
{
    if (shipment == nil || dicData == nil)
        return;
    
    shipment.bill_shipment_id = dicData[@"id_bill_shipment"];
    shipment.tunnel_index = [dicData[@"tunnel_index"] intValue];
    shipment.status = [dicData[@"status"] intValue];

    shipment.device_model_num = dicData[@"device_model_num"];
    shipment.device_num = dicData[@"device_num"];
    shipment.shipment_num = dicData[@"shipment_num"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![SZUtil isEmptyOrNull:dicData[@"start_date"]])
        shipment.start_date = [dateFormatter dateFromString:dicData[@"start_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"end_date"]])
        shipment.end_date = [dateFormatter dateFromString:dicData[@"end_date"]];
}

- (SXItemSnapshot *)getItemSnapshotFromCoredataById:(NSString *)itemSnapshotId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"item_snapshot_id = %@", itemSnapshotId];
    NSArray *result = [self arrayFromCoreData:@"SXItemSnapshot" predicate:predicate limit:1 offset:0 orderBy:nil];
    SXItemSnapshot *itemSnapshot = nil;
    if (result != nil && result.count > 0)
        itemSnapshot = result[0];
    else
    {
        itemSnapshot = (SXItemSnapshot *)[self insertIntoCoreData:@"SXItemSnapshot"];
        itemSnapshot.item_snapshot_id = itemSnapshotId;
    }
    return itemSnapshot;
}

- (void)syncItemSnapshot:(SXItemSnapshot *)itemSnapshot withItemSnapshotInfo:(NSDictionary *)dicData
{
    if (itemSnapshot == nil || dicData == nil)
        return;
    
    itemSnapshot.item_snapshot_id = dicData[@"item_snapshot_id"];
    itemSnapshot.item_id = dicData[@"id_item"];
    itemSnapshot.name = dicData[@"name"];
    itemSnapshot.pic = dicData[@"pic"];
    itemSnapshot.init_price = [dicData[@"init_price"] doubleValue];
    itemSnapshot.price = [dicData[@"price"] doubleValue];
    itemSnapshot.item_desc = dicData[@"description"];
    itemSnapshot.sku = dicData[@"sku"];
    itemSnapshot.spu = dicData[@"spu"];

    // 注意，快照不需要维护外键关联
    itemSnapshot.item_pool_id = [dicData[@"fid_item_pool"] intValue];
    itemSnapshot.item_template_id = [dicData[@"fid_item_template"] intValue];
    itemSnapshot.organization_id = [dicData[@"fid_organization"] intValue];
    itemSnapshot.category_id = [dicData[@"id_category"] intValue];

    itemSnapshot.generate_user = [dicData[@"generate_user"] stringValue];
    itemSnapshot.shop_state = [dicData[@"shop_state"] boolValue];
    itemSnapshot.suggest_location = [dicData[@"suggest_location"] intValue];
    itemSnapshot.validate = [dicData[@"validate"] intValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![SZUtil isEmptyOrNull:dicData[@"create_date"]])
        itemSnapshot.create_date = [dateFormatter dateFromString:dicData[@"create_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"generate_date"]])
        itemSnapshot.generate_date = [dateFormatter dateFromString:dicData[@"generate_date"]];
}

- (SXBillItem *)getBillItemFromCoredataById:(NSString *)billItemId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bill_item_id = %@", billItemId];
    NSArray *result = [self arrayFromCoreData:@"SXBillItem" predicate:predicate limit:1 offset:0 orderBy:nil];
    SXBillItem *billItem = nil;
    if (result != nil && result.count > 0)
        billItem = result[0];
    else
    {
        billItem = (SXBillItem *)[self insertIntoCoreData:@"SXBillItem"];
        billItem.bill_item_id = billItemId;
    }
    return billItem;
}

- (void)syncBillItem:(SXBillItem *)billItem withBillItemInfo:(NSDictionary *)dicData
{
    if (billItem == nil || dicData == nil)
        return;
    
    billItem.bill_item_id = dicData[@"id_bill_item"];
    billItem.tunnel_index = [dicData[@"tunnel_index"] intValue];
    billItem.device_model = dicData[@"device_model"];
    billItem.device_name = dicData[@"device_name"];
    billItem.device_num = dicData[@"device_num"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![SZUtil isEmptyOrNull:dicData[@"payment_date"]])
        billItem.payment_date = [dateFormatter dateFromString:dicData[@"payment_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"refund_date"]])
        billItem.refunc_date = [dateFormatter dateFromString:dicData[@"refund_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"shipment_date"]])
        billItem.shipment_date = [dateFormatter dateFromString:dicData[@"shipment_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"finish_date"]])
        billItem.finish_date = [dateFormatter dateFromString:dicData[@"finish_date"]];

    
    NSDictionary *itemSnapshotDic = dicData[@"item_snapshot_info"];
    if (itemSnapshotDic != nil)
    {
        SXItemSnapshot *itemSnapshot = [self getItemSnapshotFromCoredataById:itemSnapshotDic[@"id_item_snapshot"]];
        [self syncItemSnapshot:itemSnapshot withItemSnapshotInfo:itemSnapshotDic];
        billItem.belong_snapshot = itemSnapshot;
    }
    
    NSDictionary *shipmentDic = dicData[@"shipment_info"];
    if (shipmentDic != nil)
    {
        SXShipment *shipment = [self getShipmentFromCoredataById:shipmentDic[@"id_bill_shipment"]];
        [self syncShipment:shipment withShipmentInfo:shipmentDic];
        billItem.assign_shipment = shipment;
    }
//    billItem.bill_item_id = dicData[@"refund_info"];
}

- (SXBill *)getBillFromCoredataById:(NSString *)billId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bill_id = %@", billId];
    NSArray *result = [self arrayFromCoreData:@"SXBill" predicate:predicate limit:1 offset:0 orderBy:nil];
    SXBill *bill = nil;
    if (result != nil && result.count > 0)
        bill = result[0];
    else
    {
        bill = (SXBill *)[self insertIntoCoreData:@"SXBill"];
        bill.bill_id = billId;
    }
    return bill;
}

- (void)syncBill:(SXBill *)bill withBillInfo:(NSDictionary *)dicData
{
    if (bill == nil || dicData == nil)
        return;
    
    bill.bill_id = dicData[@"id_bill"];
    bill.customer_id = dicData[@"fid_customer"];
    bill.customer_name = dicData[@"customer_name"];
    bill.root_org_name = dicData[@"root_org_name"];
    bill.org_name = dicData[@"org_name"];
    bill.device_name = dicData[@"device_name"];

    bill.pay_method = [dicData[@"pay_method"] intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![SZUtil isEmptyOrNull:dicData[@"submit_date"]])
        bill.submit_date = [dateFormatter dateFromString:dicData[@"submit_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"pay_date"]])
        bill.pay_date = [dateFormatter dateFromString:dicData[@"pay_date"]];
    bill.pay_num = dicData[@"pay_num"];

    bill.type = [dicData[@"type"] intValue];
    bill.money = [dicData[@"money"] doubleValue];
    bill.status = [dicData[@"status"] intValue];
    bill.memo = dicData[@"memo"];
    
    NSArray *billItems = dicData[@"items"];
    for (NSDictionary *itemDic in billItems)
    {
        SXBillItem *billItem = [self getBillItemFromCoredataById:itemDic[@"id_bill_item"]];
        billItem.belong_bill = bill;
        [self syncBillItem:billItem withBillItemInfo:itemDic];
    }
}

@end

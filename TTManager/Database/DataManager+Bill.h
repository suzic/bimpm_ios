//
//  DataManager+Bill.h
//  ttmanager
//
//  Created by 苏智 on 2019/1/17.
//  Copyright © 2019 Suzic. All rights reserved.
//

#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager (Bill)

- (SXShipment *)getShipmentFromCoredataById:(NSString *)shipmentId;

- (void)syncShipment:(SXShipment *)shipment withShipmentInfo:(NSDictionary *)dicData;

- (SXItemSnapshot *)getItemSnapshotFromCoredataById:(NSString *)itemSnapshotId;

- (void)syncItemSnapshot:(SXItemSnapshot *)itemSnapshot withItemSnapshotInfo:(NSDictionary *)dicData;

- (SXBillItem *)getBillItemFromCoredataById:(NSString *)billItemId;

- (void)syncBillItem:(SXBillItem *)billItem withBillItemInfo:(NSDictionary *)dicData;

- (SXBill *)getBillFromCoredataById:(NSString *)billId;

- (void)syncBill:(SXBill *)bill withBillInfo:(NSDictionary *)dicData;

@end

NS_ASSUME_NONNULL_END

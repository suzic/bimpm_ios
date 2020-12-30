//
//  DataManager+Device.m
//  ttmanager
//
//  Created by 苏智 on 2019/1/16.
//  Copyright © 2019 Suzic. All rights reserved.
//

#import "DataManager+Device.h"

@implementation DataManager (Device)

- (SXDevicePool *)getDevicePoolFromCoredataById:(int)devicePoolId belongOrganizationId:(int)organizationId
{
    SXOrganization *organization = [self getOrganizationFromCoredataById:organizationId];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"device_pool_id = %d", devicePoolId];
    NSArray *result = [self arrayFromCoreData:@"SXDevicePool" predicate:predicate limit:1 offset:0 orderBy:nil];
    SXDevicePool *devicepool = nil;
    if (result != nil && result.count > 0)
    {
        devicepool = result[0];
    }
    else
    {
        devicepool = (SXDevicePool *)[self insertIntoCoreData:@"SXDevicePool"];
        devicepool.device_pool_id = devicePoolId;
    }
    devicepool.organization_id = organization.organization_id;
    devicepool.belong_organization = organization;

    return devicepool;
}

- (SXDeviceModel *)getModelFromCoredataById:(int)modelId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"model_id = %d", modelId];
    NSArray *result = [self arrayFromCoreData:@"SXDeviceModel" predicate:predicate limit:1 offset:0 orderBy:nil];
    SXDeviceModel *model = nil;
    if (result != nil && result.count > 0)
        model = result[0];
    else
    {
        model = (SXDeviceModel *)[self insertIntoCoreData:@"SXDeviceModel"];
        model.model_id = modelId;
    }
    return model;
}

- (void)syncModel:(SXDeviceModel *)model withModelInfo:(NSDictionary *)dicData;
{
    if (model == nil || dicData == nil)
        return;
    
    model.model_id = [dicData[@"id_device_model"] intValue];
    model.name = dicData[@"name"];
    model.num = dicData[@"num"];
}

- (SXDevice *)getDeviceFromCoredataById:(int)deviceId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"device_id = %d", deviceId];
    NSArray *result = [self arrayFromCoreData:@"SXDevice" predicate:predicate limit:1 offset:0 orderBy:nil];
    SXDevice *device = nil;
    if (result != nil && result.count > 0)
        device = result[0];
    else
    {
        device = (SXDevice *)[self insertIntoCoreData:@"SXDevice"];
        device.device_id = deviceId;
    }
    return device;
}

- (void)syncDevice:(SXDevice *)device withDeviceInfo:(NSDictionary *)dicData
{
    if (device == nil || dicData == nil)
        return;
    
    device.device_id = [dicData[@"id_device"] intValue];
    device.device_pool_id = [dicData[@"fid_device_pool"] intValue];
    device.organization_id = [dicData[@"fid_organization"] intValue];
    if (device.device_pool_id != 0 && device.organization_id != 0)
    {
        SXDevicePool *pool = [self getDevicePoolFromCoredataById:device.device_pool_id belongOrganizationId:device.organization_id];
        device.belong_pool = pool;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![SZUtil isEmptyOrNull:dicData[@"create_date"]])
        device.create_date = [dateFormatter dateFromString:dicData[@"create_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"modify_date"]])
        device.first_sale_date = [dateFormatter dateFromString:dicData[@"first_sale_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"first_sale_date"]])
        device.deploy_date = [dateFormatter dateFromString:dicData[@"deploy_date"]];
    if (![SZUtil isEmptyOrNull:dicData[@"last_time"]])
        device.deploy_date = [dateFormatter dateFromString:dicData[@"last_time"]];

    device.name = dicData[@"name"];
    device.num = dicData[@"num"];
    device.batch_model_num = dicData[@"batch_model_num"];
    device.device_model_id = [dicData[@"fid_device_model"] intValue];
    device.humidity = [dicData[@"humidity"] doubleValue];
    device.interface_num = dicData[@"interface_num"];
    device.model_num = dicData[@"model_num"];
    device.online = [dicData[@"online"] intValue];
    device.org_contact_phone = dicData[@"org_contact_phone"];
    device.org_name = dicData[@"org_name"];
    device.pic = dicData[@"pic"];
    device.sig = [dicData[@"sig"] doubleValue];
    device.stock_state = [dicData[@"stock_state"] intValue];
    device.temperature = [dicData[@"temperature"] doubleValue];
    device.warning_hum_high = [dicData[@"warning_hum_high"] doubleValue];
    device.warning_hum_low = [dicData[@"warning_hum_low"] doubleValue];
    device.warning_temp_high = [dicData[@"warning_temp_high"] doubleValue];
    device.warning_temp_low = [dicData[@"warning_temp_low"] doubleValue];
}

- (SXDeviceTunnel *)getDeviceTunnelFromCoredataById:(int)deviceTunnelId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tunnel_id = %d", deviceTunnelId];
    NSArray *result = [self arrayFromCoreData:@"SXDeviceTunnel" predicate:predicate limit:1 offset:0 orderBy:nil];
    SXDeviceTunnel *tunnel = nil;
    if (result != nil && result.count > 0)
        tunnel = result[0];
    else
    {
        tunnel = (SXDeviceTunnel *)[self insertIntoCoreData:@"SXDeviceTunnel"];
        tunnel.tunnel_id = deviceTunnelId;
    }
    return tunnel;
}

- (void)syncDeviceTunnel:(SXDeviceTunnel *)tunnel withDeviceTunnelInfo:(NSDictionary *)dicData
{
    if (tunnel == nil || dicData == nil)
        return;
    
    tunnel.tunnel_id = [dicData[@"id_device_tunnel"] intValue];
    tunnel.device_id = [dicData[@"fid_device"] intValue];
    tunnel.device_num = dicData[@"device_num"];
    if (tunnel.device_id != 0)
    {
        SXDevice *device = [self getDeviceFromCoredataById:tunnel.device_id];
        tunnel.belong_device = device;
    }
    tunnel.item_count_current = [dicData[@"count_current"] intValue];
    tunnel.item_count_locked = [dicData[@"count_locked"] intValue];
    tunnel.count_threshold = [dicData[@"count_low"] intValue];
    tunnel.item_count_max = [dicData[@"count_max"] intValue];
    
    tunnel.item_id = dicData[@"fid_item"];
    if (![SZUtil isEmptyOrNull:tunnel.item_id])
    {
        SXItem *item = [self getItemFromCoredataById:tunnel.item_id];
        item.name = dicData[@"item_snap_shot_name"];
        item.pic = dicData[@"item_snap_shot_pic"];
        item.price = [dicData[@"price"] doubleValue];
        item.sku = dicData[@"sku"];
        tunnel.assign_item = item;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (![SZUtil isEmptyOrNull:dicData[@"last_refill_date"]])
        tunnel.last_refill_date = [dateFormatter dateFromString:dicData[@"last_refill_date"]];

    tunnel.tunnel_index = [dicData[@"tunnel_index"] intValue];
    tunnel.locked = ([dicData[@"tunnel_lock"] intValue] == 1);
    tunnel.type = [dicData[@"type"] intValue];
    tunnel.state = [dicData[@"state"] intValue];
}

@end

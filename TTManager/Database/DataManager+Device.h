//
//  DataManager+Device.h
//  ttmanager
//
//  Created by 苏智 on 2019/1/16.
//  Copyright © 2019 Suzic. All rights reserved.
//

#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager (Device)

- (SXDevicePool *)getDevicePoolFromCoredataById:(int)devicePoolId belongOrganizationId:(int)organizationId;

- (SXDeviceModel *)getModelFromCoredataById:(int)modelId;

- (void)syncModel:(SXDeviceModel *)model withModelInfo:(NSDictionary *)dicData;

- (SXDevice *)getDeviceFromCoredataById:(int)deviceId;

- (void)syncDevice:(SXDevice *)device withDeviceInfo:(NSDictionary *)dicData;

- (SXDeviceTunnel *)getDeviceTunnelFromCoredataById:(int)deviceTunnelId;

- (void)syncDeviceTunnel:(SXDeviceTunnel *)tunnel withDeviceTunnelInfo:(NSDictionary *)dicData;

@end

NS_ASSUME_NONNULL_END

//
//  DataManager+Item.h
//  ttmanager
//
//  Created by 苏智 on 2019/1/17.
//  Copyright © 2019 Suzic. All rights reserved.
//

#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager (Item)

- (SXItemPool *)getItemPoolFromCoredataById:(int)itemPoolId belongOrganizationId:(int)organizationId;

- (SXItem *)getItemFromCoredataById:(NSString *)itemId;

- (void)syncItem:(SXItem *)item withItemInfo:(NSDictionary *)dicData;

@end

NS_ASSUME_NONNULL_END

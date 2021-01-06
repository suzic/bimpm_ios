//
//  PageSize.h
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageSize : NSObject

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, assign) NSInteger total_row;

- (NSDictionary *)currentPage;
- (PageSize *)pageDic:(NSDictionary *)page;
@end

NS_ASSUME_NONNULL_END

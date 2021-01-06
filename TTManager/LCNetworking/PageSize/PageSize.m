//
//  PageSize.m
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "PageSize.h"

@implementation PageSize

- (instancetype)init{
    self = [super init];
    if (self) {
        self.orders = [NSMutableArray array];
        self.filters = [NSMutableArray array];
    }
    return self;
}
- (NSDictionary *)currentPage{
    NSString *pageSizeString = [NSString stringWithFormat:@"%ld", self.pageSize];
    NSString *pageIndexString = [NSString stringWithFormat:@"%ld", self.pageIndex];
    NSDictionary * dict = @{@"page_size":pageSizeString,
                            @"page_index":pageIndexString,
                            @"total_pages":@"",
                            @"current_count":@"",
                            @"orders":self.orders,
                            @"filter":self.filters};
    return dict;
}
- (PageSize *)pageDic:(NSDictionary *)page{
    PageSize *pageSize = [[PageSize alloc] init];
    pageSize.pageSize = [page[@"page_size"] integerValue];
    pageSize.pageIndex = [page[@"page_index"] integerValue];
    pageSize.totalPages = [page[@"total_pages"] integerValue];
    pageSize.currentCount = [page[@"current_count"] integerValue];
    pageSize.total_row = [page[@"total_row"] integerValue];
    return pageSize;
}
@end

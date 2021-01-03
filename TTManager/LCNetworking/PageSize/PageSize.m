//
//  PageSize.m
//  TTManager
//
//  Created by chao liu on 2021/1/3.
//

#import "PageSize.h"

@implementation PageSize

- (NSDictionary *)currentPage{
    NSString *pageSizeString = [NSString stringWithFormat:@"%ld", self.pageSize];
    NSString *pageIndexString = [NSString stringWithFormat:@"%ld", self.pageIndex];
    NSDictionary * dict = @{@"page_size":pageSizeString, @"page_index":pageIndexString, @"total_pages":@"", @"current_count":@""};
    return dict;
}
@end

//
//  UITableView+EmptyView.m
//  TTManager
//
//  Created by chao liu on 2021/1/4.
//

#import "UITableView+EmptyView.h"

@implementation UITableView (EmptyView)

- (void)showDataCount:(NSInteger)count{
    if (count > 0) {
        self.backgroundView = nil;
        return;
    }
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    UIImageView *showImageView = [[UIImageView alloc]init];
    showImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backgroundView addSubview:showImageView];
    
    showImageView.image = [UIImage imageNamed:@"empty_image"];
 
    [showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backgroundView.mas_centerX);
        make.centerY.mas_equalTo(backgroundView.mas_centerY).mas_offset(-20);
    }];
   
    self.backgroundView = backgroundView;
}
@end

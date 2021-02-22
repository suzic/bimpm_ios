//
//  UITableView+EmptyView.m
//  TTManager
//
//  Created by chao liu on 2021/1/4.
//

#import "UITableView+EmptyView.h"

@implementation UITableView (EmptyView)

- (void)showDataCount:(NSInteger)count type:(NSInteger)type{
    if (count > 0) {
        self.backgroundView = nil;
        return;
    }
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    if (type == 3) {
        [self noticeEmptyView:backgroundView];
    }else{
        UIImageView *showImageView = [[UIImageView alloc]init];
        showImageView.contentMode = UIViewContentModeScaleAspectFill;
        [backgroundView addSubview:showImageView];
        showImageView.image = [UIImage imageNamed:[self emptyImageName:type]];
        [showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backgroundView);
            make.centerY.equalTo(backgroundView);
            make.width.height.equalTo(200);
        }];
    }
    
    self.backgroundView = backgroundView;
}

- (void)noticeEmptyView:(UIView *)bgView{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24.0f];
    label.textColor = [UIColor blackColor];
    label.text = @"暂无公告";
    [bgView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.centerY.equalTo(bgView);
    }];
}

- (NSString *)emptyImageName:(NSInteger)type{
    NSString *empty_image = @"empty_image";
    switch (type) {
        case 0:
            empty_image = @"empty_image";
            break;
        case 1:
            empty_image = @"my_task_empty";
            break;
        case 2:
            empty_image = @"my_draft_empty";
            break;
        default:
            break;
    }
    return empty_image;
}
@end

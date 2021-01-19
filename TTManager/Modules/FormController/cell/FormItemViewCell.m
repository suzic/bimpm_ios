//
//  FormItemViewCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/19.
//

#import "FormItemViewCell.h"

@implementation FormItemViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

#pragma mark - UI
- (void)addUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
}
@end

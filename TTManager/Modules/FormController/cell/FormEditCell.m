//
//  FormEditCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import "FormEditCell.h"
#import "FormItemView.h"

@interface FormEditCell ()

@property (nonatomic, strong) FormItemView *formItemView;

@end
@implementation FormEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI{
    [self.contentView addSubview:self.formItemView];
    [self.formItemView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}
- (FormItemView *)formItemView{
    if (_formItemView == nil) {
        _formItemView = [[FormItemView alloc] initWithItemType:formItemType_edit];
    }
    return _formItemView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

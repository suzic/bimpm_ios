//
//  FormViewCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/19.
//

#import "FormViewCell.h"

@interface FormViewCell ()

@property (nonatomic, strong) UILabel *formName;
@property (nonatomic, strong) UILabel *formStatus;
@property (nonatomic, strong) UILabel *formTitle;
@property (nonatomic, strong) UILabel *formTargetName;
@property (nonatomic, strong) UIImageView *formUserImage;
@property (nonatomic, strong) UILabel *formUserName;
@property (nonatomic, strong) UILabel *formLastDate;

@end

@implementation FormViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    self.formUserImage.clipsToBounds = YES;
    self.formUserImage.layer.cornerRadius = _formUserImage.frame.size.height/2;
}
#pragma mark - setter and getter
- (void)setCurrentForm:(ZHForm *)currentForm{
    if (_currentForm != currentForm) {
        _currentForm = currentForm;
        self.formName.text = _currentForm.uid_ident;
        self.formTitle.text = _currentForm.name;
        self.formTargetName.text = _currentForm.buddyFile.name;
        self.formUserName.text = _currentForm.update_user;
        self.formLastDate.text = [SZUtil getTimeString:_currentForm.update_date withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [self.formUserImage sd_setImageWithURL:[NSURL URLWithString:_currentForm.lastEditor.avatar] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
        if ([SZUtil isEmptyOrNull:_currentForm.buddyFile.uid_target]) {
            self.formStatus.text = @"设计中";
        }else{
            self.formStatus.text = @"已制表";
        }
    }
}
-(UILabel *)formName{
    if (_formName == nil) {
        _formName = [[UILabel alloc] init];
        _formName.textAlignment = NSTextAlignmentCenter;
        _formName.font = [UIFont systemFontOfSize:14];
        _formName.textColor = RGB_COLOR(51, 51, 51);
    }
    return _formName;
}
- (UILabel *)formTitle{
    if (_formTitle == nil) {
        _formTitle = [[UILabel alloc] init];
        _formTitle.font = [UIFont systemFontOfSize:14];
        _formTitle.textColor = RGB_COLOR(51, 51, 51);
    }
    return _formTitle;
}
- (UILabel *)formStatus{
    if (_formStatus == nil) {
        _formStatus = [[UILabel alloc] init];
        _formStatus.backgroundColor = RGB_COLOR(5, 125, 255);
        _formStatus.textAlignment = NSTextAlignmentCenter;
        _formStatus.textColor = [UIColor whiteColor];
        _formStatus.font = [UIFont systemFontOfSize:13];
    }
    return _formStatus;
}
- (UILabel *)formTargetName{
    if (_formTargetName == nil) {
        _formTargetName = [[UILabel alloc] init];
        _formTargetName.font = [UIFont systemFontOfSize:13];
        _formTargetName.textColor = RGB_COLOR(51, 51, 51);
        _formTargetName.textColor = RGB_COLOR(4, 126, 255);
    }
    return _formTargetName;
}
-(UILabel *)formUserName{
    if (_formUserName == nil) {
        _formUserName = [[UILabel alloc] init];
        _formUserName.textAlignment = NSTextAlignmentRight;
        _formUserName.font = [UIFont systemFontOfSize:14];
        _formUserName.textColor = RGB_COLOR(51, 51, 51);
    }
    return _formUserName;
}
-(UIImageView *)formUserImage{
    if (_formUserImage == nil) {
        _formUserImage = [[UIImageView alloc] init];
    }
    return _formUserImage;
}
- (UILabel *)formLastDate{
    if (_formLastDate == nil) {
        _formLastDate = [[UILabel alloc] init];
        _formLastDate.textAlignment = NSTextAlignmentRight;
        _formLastDate.font = [UIFont systemFontOfSize:13];
        _formLastDate.textColor = RGB_COLOR(51, 51, 51);
    }
    return _formLastDate;
}
- (void)addUI{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    UIView *leftView = [[UIView alloc] init];
    [bgView addSubview:leftView];
    [leftView addSubview:self.formName];
    [leftView addSubview:self.formStatus];
    
    UIView *centreView = [[UIView alloc] init];
    [bgView addSubview:centreView];
    [centreView addSubview:self.formTitle];
    [centreView addSubview:self.formTargetName];
    
    UIView *rightView = [[UIView alloc] init];
    [bgView addSubview:rightView];
    [rightView addSubview:self.formUserName];
    [rightView addSubview:self.formLastDate];
    
    [bgView addSubview:self.formUserImage];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    [leftView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(0);
        make.top.equalTo(10);
        make.width.equalTo(60);
    }];
    [self.formName makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(leftView.mas_height).multipliedBy(0.5);
    }];
    [self.formStatus makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.formName.mas_bottom);
        make.height.equalTo(20);
    }];
    
    [centreView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(20);
        make.top.equalTo(10);
        make.bottom.equalTo(0);
    }];
    [self.formTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(leftView.mas_height).multipliedBy(0.5);
    }];
    [self.formTargetName makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.formTitle.mas_bottom);
        make.height.equalTo(20);
    }];
    
    
    [rightView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.bottom.equalTo(0);
        make.width.equalTo(130);
        make.left.equalTo(centreView.mas_right).offset(10);
    }];
    [self.formUserName makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(rightView.mas_height).multipliedBy(0.5);
    }];
    [self.formLastDate makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.formUserName.mas_bottom);
        make.height.equalTo(20);
    }];
    [self.formUserImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView.mas_right).offset(10);
        make.right.equalTo(-10);
        make.top.equalTo(15);
        make.bottom.equalTo(-15);
        make.width.equalTo(self.formUserImage.mas_height);
    }];
    
    bgView.layer.cornerRadius = 5;
    bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:9/255.0 blue:25/255.0 alpha:0.1].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    bgView.layer.shadowOpacity = 1;
    bgView.layer.shadowRadius = 10;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

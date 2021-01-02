//
//  FrameNavView.m
//  TTManager
//
//  Created by chao liu on 2020/12/25.
//

#import "FrameNavView.h"
#import "PopViewController.h"

@interface FrameNavView ()<PopViewSelectedIndexDelegate,UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong)  UIButton *userAvatar;
@property (nonatomic, strong)  UIButton *changeProjectBtn;

@end

@implementation FrameNavView

//+ (instancetype)initFrameNavView{
//    FrameNavView *view = [[NSBundle mainBundle] loadNibNamed:@"FrameNavView" owner:nil options:nil][0];
//    view.backgroundColor = RGB_COLOR(5, 125, 255);
//    [view.changeProjectBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//    return  view;
//}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self addUI];

    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
    }
    return self;
}
- (void)addUI{
    self.backgroundColor = RGB_COLOR(5, 125, 255);
    [self addSubview:self.userAvatar];
    [self addSubview:self.changeProjectBtn];
    [self.userAvatar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.width.height.equalTo(32);
        make.bottom.equalTo(-8);
    }];
    [self.changeProjectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(240);
        make.centerY.equalTo(self.userAvatar.mas_centerY);
        make.centerX.equalTo(self);
        make.height.equalTo(44);
    }];
    [self layoutIfNeeded];
    self.userAvatar.clipsToBounds = YES;
    self.userAvatar.layer.cornerRadius = 16.0f;
}
#pragma mark - setter and getter
- (UIButton *)userAvatar{
    if (_userAvatar == nil) {
        _userAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userAvatar setBackgroundImage:[UIImage imageNamed:@"test-1"] forState:UIControlStateNormal];
        [_userAvatar addTarget:self action:@selector(clickuserAvatarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAvatar;
}
- (UIButton *)changeProjectBtn{
    if (_changeProjectBtn == nil) {
        _changeProjectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeProjectBtn setImage:[UIImage imageNamed:@"button_ down"] forState:UIControlStateNormal];
        [_changeProjectBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_changeProjectBtn addTarget:self action:@selector(changeProjectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_changeProjectBtn setTitle:@"众和空间" forState:UIControlStateNormal];
        _changeProjectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return _changeProjectBtn;
}
- (void)changeProjectAction:(UIButton *)sender {
    [self showPopView:self.changeProjectBtn];
}
- (void)clickuserAvatarAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSettings object:nil];
}
- (void)showPopView:(UIView *)sourceView
{
    PopViewController *popView = [[PopViewController alloc] init];
    popView.delegate = self;
    popView.view.alpha = 1.0;
    popView.dataList = @[@"价格高到低",@"价格低到高"];
    popView.modalPresentationStyle = UIModalPresentationPopover;
    
    popView.popoverPresentationController.sourceView = sourceView;
    popView.popoverPresentationController.sourceRect = CGRectMake(sourceView.frame.origin.x, sourceView.frame.origin.y, 0, 0);
    popView.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    popView.popoverPresentationController.delegate = self;
    [[SZUtil getCurrentVC] presentViewController:popView animated:YES completion:nil];
}
#pragma mark - PopViewSelectedIndexDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}
- (void)popViewControllerSelectedCellIndexContent:(NSIndexPath *)indexPath{
//    [self performSegueWithIdentifier:@"showSelectedProject" sender:nil];
//    self.projectView.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSelectProject object:@{@"currentProject":@""}];
}
// 暂时不需要
- (void)transformButtonImage:(BOOL)down{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:down == YES ? 0.0 :M_PI];
    rotationAnimation.toValue = [NSNumber numberWithFloat: down == YES ? M_PI :0];
    rotationAnimation.duration = 0.4;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.changeProjectBtn.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

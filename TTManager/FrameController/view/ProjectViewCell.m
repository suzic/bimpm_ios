//
//  ProjectViewCell.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "ProjectViewCell.h"

@interface ProjectViewCell ()


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *infor;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIView *toolView;

@end

@implementation ProjectViewCell

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.maskView.hidden = YES;
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.bgView.layer.shadowOpacity = 0.3f;
    self.bgView.layer.shadowRadius = 4.0f;
}

- (void)setUserProject:(ZHUserProject *)userProject{
    if (_userProject != userProject) {
        _userProject = userProject;
        [self.projectImage sd_setImageWithURL:[NSURL URLWithString:userProject.belongProject.snap_image] placeholderImage:[UIImage imageNamed:@"defaultProjectBg"]];
        [self setmaskViewStyle:_userProject];
        self.projectName.text = userProject.belongProject.name;
    }
}
- (void)setmaskViewStyle:(ZHUserProject *)userProject {
    NSLog(@"当前项目名称%@",userProject.belongProject.name);
    if (userProject.in_invite == 1) {
        self.maskView.hidden = NO;
        NSString *text = [NSString stringWithFormat:@"%@邀请您加入",_userProject.invite_user];
        self.infor.text = text;
        self.middleBtn.hidden = YES;
        self.toolView.hidden = NO;
    }else if(userProject.in_manager_invite == 1){
        self.maskView.hidden = NO;
        self.infor.text = @"管理员邀请您加入";
        self.middleBtn.hidden = YES;
        self.toolView.hidden = NO;
    }else if(userProject.in_apply == 1){
        self.maskView.hidden = NO;
        self.infor.text = @"申请加入中";
        [self.middleBtn setTitle:@"放弃申请" forState:UIControlStateNormal];
        [self.middleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.middleBtn.backgroundColor = [UIColor whiteColor];
        self.toolView.hidden = YES;
    }else{
        self.maskView.hidden = YES;
    }
}
- (IBAction)agreeAction:(id)sender {
    [self routerEventWithName:user_to_project_operations userInfo:@{@"code":@"ACCEPT",@"param":@"1",@"id_project":INT_32_TO_STRING(self.userProject.belongProject.id_project)}];
}
- (IBAction)rejectAction:(id)sender {
    [self routerEventWithName:user_to_project_operations userInfo:@{@"code":@"ACCEPT",@"param":@"0",@"id_project":INT_32_TO_STRING(self.userProject.belongProject.id_project)}];
}

- (IBAction)middleAction:(id)sender {
    [self routerEventWithName:user_to_project_operations userInfo:@{@"code":@"APPLY",@"param":@"0",@"id_project":INT_32_TO_STRING(self.userProject.belongProject.id_project)}];
}

@end

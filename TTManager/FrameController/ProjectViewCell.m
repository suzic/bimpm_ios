//
//  ProjectViewCell.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "ProjectViewCell.h"

@implementation ProjectViewCell

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self borderForColor:[UIColor groupTableViewBackgroundColor] borderWidth:0.5 borderType:UIBorderSideTypeAll];
    }
    return self;
    
}
- (void)setUserProject:(ZHUserProject *)userProject{
    if (_userProject != userProject) {
        _userProject = userProject;
        [self.projectImage sd_setImageWithURL:[NSURL URLWithString:userProject.belongProject.snap_image] placeholderImage:[UIImage imageNamed:@"empty_image"]];
        NSLog(@"参与的项目列表=====%@",userProject.belongProject.snap_image);
        self.joinBtn.hidden = userProject.in_manager_invite == 0;
        self.projectName.text = userProject.belongProject.name;
        self.joinBtn.hidden = NO;
        if (_userProject.in_invite == 1) {
            self.joinBtn.hidden = NO;
//            self.joinBtn.titleLabel.text = @"";
            [self.joinBtn setTitle:@"申请加入中" forState:UIControlStateNormal];
        }else if(_userProject.in_manager_invite == 1){
            [self.joinBtn setTitle:@"管理员邀请您加入" forState:UIControlStateNormal];
        }else if(_userProject.in_apply == 1){
//            NSString *text = [NSString stringWithFormat:@"%@邀请您加入",_userProject.invite_user];
            [self.joinBtn setTitle:@"申请加入中" forState:UIControlStateNormal];
        }
        else{
            self.joinBtn.hidden = YES;
        }
    }
}

@end

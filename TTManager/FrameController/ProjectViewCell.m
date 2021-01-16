//
//  ProjectViewCell.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "ProjectViewCell.h"

@implementation ProjectViewCell

- (void)setUserProject:(ZHUserProject *)userProject{
    if (_userProject != userProject) {
        _userProject = userProject;
        [self.projectImage sd_setImageWithURL:[NSURL URLWithString:userProject.belongProject.snap_image] placeholderImage:[UIImage imageNamed:@"empty_image"]];
        NSLog(@"参与的项目列表=====%@",userProject.belongProject.snap_image);
        self.joinBtn.hidden = userProject.in_manager_invite == 0;
        self.projectName.text = userProject.belongProject.name;
        if (_userProject.in_invite == 1 ||_userProject.in_manager_invite == 1 || _userProject.in_apply == 1) {
            self.joinBtn.hidden = NO;
            self.joinBtn.titleLabel.text = @"等待接受邀请";
        }else{
            self.joinBtn.hidden = YES;
        }
    }
}

@end

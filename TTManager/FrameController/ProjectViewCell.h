//
//  ProjectViewCell.h
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectViewCell : UICollectionViewCell

@property (nonatomic, strong)ZHUserProject *userProject;

@property (weak, nonatomic) IBOutlet UIImageView *projectImage;
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end

NS_ASSUME_NONNULL_END

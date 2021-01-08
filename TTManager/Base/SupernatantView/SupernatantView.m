//
//  SupernatantView.m
//  TTManager
//
//  Created by chao liu on 2021/1/8.
//

#import "SupernatantView.h"

@interface SupernatantView ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *ImageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SupernatantView

+ (instancetype)initSupernatantViewInView:(UIView *)view{
    SupernatantView *supernatantView = [[SupernatantView alloc] init];
    [supernatantView addUI];
    [view addSubview:supernatantView];
    return supernatantView;
}
- (void)addUI{
    self.backgroundColor = [UIColor clearColor];
    self.textLabel = [[UILabel alloc] init];
    
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

    self.ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"supernatant_bgImage"]];
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"supernatant_arrow"]];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.ImageView];
    [self addSubview:self.bgImageView];
    [self addSubview:self.textLabel];
}
- (void)showframe:(CGRect)frame text:(NSString *)text;{
    self.hidden = NO;
    self.textLabel.text = text;
    CGSize titleSize = [self.textLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.textLabel.font} context:nil].size;
    self.frame = CGRectMake(0, 0, titleSize.width+10, titleSize.height+20);
    self.ImageView.frame = CGRectMake(0, 0, self.frame.size.width, titleSize.height+10);
    self.textLabel.frame = CGRectMake(5, 5, titleSize.width, titleSize.height);
    CGRect currenFrame = self.frame;
    // 当前点击的item的上边框中心距离左侧距离
    CGFloat clickCenter = (frame.origin.x+frame.size.width/2);
    // 当前显示的View的上边框中心距离左侧距离
    CGFloat selectedViewCenter = currenFrame.size.width/2;

    // 此时点击的位置不足以显示View 需要调整并且做图片的拉伸
    if (clickCenter < selectedViewCenter)// 左侧
    {
        currenFrame.origin = CGPointMake(frame.origin.x+5, frame.origin.y-currenFrame.size.height);
        self.frame = currenFrame;
        self.bgImageView.frame = CGRectMake(clickCenter-9, self.frame.size.height-18, 16, 18);
    }
    else if ((kScreenWidth-30-clickCenter) < selectedViewCenter)// 右侧
    {
        currenFrame.origin = CGPointMake(kScreenWidth-30-self.frame.size.width-5, frame.origin.y-currenFrame.size.height);
        self.frame = currenFrame;
        self.bgImageView.frame = CGRectMake(self.frame.size.width-5-(kScreenWidth-30-clickCenter), self.frame.size.height-18, 16, 18);
    }
    else // 此时点击的位置可以正常显示View
    {
        self.center = CGPointMake(clickCenter, frame.origin.y-currenFrame.size.height/2+10);
        self.bgImageView.frame = CGRectMake((self.frame.size.width-18)/2, self.frame.size.height-18, 16, 18);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

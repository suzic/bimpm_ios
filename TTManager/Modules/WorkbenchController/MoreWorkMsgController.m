//
//  MoreWorkMsgController.m
//  TTManager
//
//  Created by chao liu on 2020/12/28.
//

#import "MoreWorkMsgController.h"
#import "MessageView.h"

@interface MoreWorkMsgController ()
@property (nonatomic, strong) MessageView *messageView;
@end

@implementation MoreWorkMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息详情";
    [self addUI];
}
- (void)addUI{
    [self.view addSubview:self.messageView];
    [self.messageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(self.view).multipliedBy(0.5);
    }];
}
#pragma mark - setter and getter
- (MessageView *)messageView{
    if (_messageView == nil) {
        _messageView = [[MessageView alloc] init];
        _messageView.backgroundColor = RGB_COLOR(72, 147, 241);
    }
    return _messageView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

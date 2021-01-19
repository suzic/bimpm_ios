//
//  FormListController.m
//  TTManager
//
//  Created by chao liu on 2021/1/19.
//

#import "FormListController.h"
#import "TabListView.h"
#import "TaskListView.h"
#import "DragButton.h"

@interface FormListController ()

@property (nonatomic, strong) TabListView *formTabView;
@property (nonatomic, strong) NSMutableArray *formListArray;
@property (nonatomic, strong) NSMutableArray *formStatustArray;
@end

@implementation FormListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"表单列表";
    [self addUI];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.formTabView.selectedTaskIndex = 0;
}
#pragma mark - UI
- (void)addUI{
    [self.view addSubview:self.formTabView];
    self.formTabView.listType = 2;
    [self.formTabView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    self.formListArray = [NSMutableArray array];
    for (NSNumber *status in self.formStatustArray) {
        TaskListView *view = [[TaskListView alloc] init];
        view.listType = 2;
        view.formType = [status integerValue];
        view.listTitle = [self getListTitleWithStatus:[status integerValue]];
        view.needReloadData = YES;
        [self.formListArray addObject:view];
    }
    [self.view layoutIfNeeded];
    [self.formTabView setChildrenViewList:self.formListArray];
    DragButton *dragBtn = [DragButton initDragButtonVC:self];
    [dragBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(-(SafeAreaBottomHeight == 0 ? 15 :SafeAreaBottomHeight));
        make.width.height.equalTo(49);
    }];
}
// 当前list的title
- (NSString *)getListTitleWithStatus:(NSInteger)status{
    NSString *listTitle = @"";
    switch (status) {
        case 1:
            listTitle = @"标准表单";
            break;
        case 2:
            listTitle = @"自定义表单";
            break;
        default:
            break;
    }
    return listTitle;
}
#pragma mark - setter getter
- (TabListView *)formTabView{
    if (_formTabView == nil) {
        _formTabView = [[TabListView alloc] init];
    }
    return _formTabView;
}
- (NSMutableArray *)formStatustArray{
    if (_formStatustArray == nil) {
        _formStatustArray = [NSMutableArray arrayWithObjects:@(1),@(2), nil];
    }
    return _formStatustArray;
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

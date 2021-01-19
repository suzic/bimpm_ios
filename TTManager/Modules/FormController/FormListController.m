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
#import "FormController.h"

@interface FormListController ()<UITextFieldDelegate>

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

#pragma mark -private
- (void)showNewFormAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请表单名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSString *fileName = alertController.textFields[0].text;
        if ([SZUtil isEmptyOrNull:fileName]) {
            [CNAlertView showWithTitle:@"表单名不能为空" message:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    // 调用新建form接口
                }
            }];
            return;
        }
    }]];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新建表单名称";
        textField.delegate = self;
    }];
    [self presentViewController:alertController animated:true completion:nil];
}
- (void)goFormDetailsViewController:(NSString *)uid_form{
    FormController *vc = [[FormController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - responder chain
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:form_selected_item]) {
        NSString *uid_form = userInfo[@"uid_form"];
        [self goFormDetailsViewController:uid_form];
    }else if([eventName isEqualToString:new_task_action]){
        [self showNewFormAlert];
    }
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

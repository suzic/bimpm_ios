//
//  TaskListView.m
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import "TaskListView.h"
#import "TaskListCell.h"

@interface TaskListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TaskListView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
- (void)addUI{
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
#warning UITableView 设置为group时，如果只设置header的高度，不设置 headerView，会出现留白
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"taskCell";
    TaskListCell *cell = (TaskListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell =[[TaskListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }

    cell.taskName.text = [self getListTitleWithStatus:self.taskStatus];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self routerEventWithName:Task_list_selected userInfo:@{}];
}

- (NSString *)getListTitleWithStatus:(TaskStatus)status{
    NSString *listTitle = @"";
    switch (status) {
        case Task_list:
            listTitle = @"我的任务";
            break;
        case Task_finish:
            listTitle = @"已完成任务";
            break;
        case Task_sponsoring:
            listTitle = @"正在发起";
            break;
        case Task_sponsored:
            listTitle = @"已发起";
            break;
        default:
            break;
    }
    return listTitle;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  PollingFormView.m
//  TTManager
//
//  Created by chao liu on 2021/2/8.
//

#import "PollingFormView.h"
#import "FormEditCell.h"
#import "FormItemSectionView.h"

static NSString *textCellIndex = @"textCellIndex";
static NSString *headerCell = @"headerCell";

@interface PollingFormView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/// 当前展开的section
@property (nonatomic, strong) NSMutableArray *expandSectionArray;

@end

@implementation PollingFormView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addUI];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *sectionString = [NSString stringWithFormat:@"%ld",section];
    BOOL isExpand = [self.expandSectionArray containsObject:sectionString];
    switch (section) {
        case 0:
            return isExpand == YES ? 6:0;
            break;
        case 1:
            return isExpand == YES ? 4:0;
            break;
        case 2:
            return isExpand == YES ? 2:0;
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    FormItemSectionView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerCell];
    NSDictionary *dic = @{@"name":@"姓名",@"instance_value":@"liuchao"};
    [headerView setIsFormEdit:NO indexPath:[NSIndexPath indexPathForRow:0 inSection:section] item:dic];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandSection:)];
    headerView.tag = section;
    [headerView addGestureRecognizer:tap];
    headerView.contentView.backgroundColor = [UIColor lightGrayColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
//    NSArray *items = self.formFlowManager.instanceDownLoadForm[@"items"];
//    NSDictionary *formItem = items[indexPath.row];
    
    FormEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:textCellIndex];
    if (!editCell) {
        editCell = [[FormEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIndex];
    }
//        editCell.templateType = 2;
//    [editCell setIsFormEdit:self.formFlowManager.isEditForm indexPath:indexPath item:formItem];
    cell = editCell;
    
    return cell;
}

#pragma mark - private
// 点击展开section
- (void)expandSection:(UITapGestureRecognizer *)tap{
    UIView *header = tap.view;
    NSInteger section = header.tag;
    NSString *sectionString = [NSString stringWithFormat:@"%ld",section];
    // 已经展开点击收起，否则展开
    if ([self.expandSectionArray containsObject:sectionString]) {
        [self.expandSectionArray removeObject:sectionString];
    }else{
        [self.expandSectionArray addObject:sectionString];
    }
    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UI

- (void)addUI{
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
}

#pragma mark - setter and getter

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //直接用估算高度
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FormItemSectionView class] forHeaderFooterViewReuseIdentifier:headerCell];
    }
    return _tableView;
}

- (NSMutableArray *)expandSectionArray{
    if (_expandSectionArray == nil) {
        _expandSectionArray = [NSMutableArray array];
    }
    return _expandSectionArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

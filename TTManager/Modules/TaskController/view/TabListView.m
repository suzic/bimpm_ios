//
//  TabListView.m
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import "TabListView.h"
#import "TaskListView.h"
#import "TaskSearchView.h"

@interface TabListView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *tabToolView;
@property (nonatomic, strong) TaskSearchView *searchView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// 任务列表的集合
@property (nonatomic, strong) NSMutableArray *taskListViewArray;
@property (nonatomic, strong) NSMutableArray *tabButtonArray;
@end

@implementation TabListView

- (instancetype)init{
    self = [super init];
    if (self) {
        _selectedTaskIndex = NSNotFound;
        self.tabButtonArray = [NSMutableArray array];
        self.taskListViewArray = [NSMutableArray array];
    }
    return self;
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat x = w/self.tabButtonArray.count/w*offsetX;
    [self.lineView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(x);
    }];
    _selectedTaskIndex = offsetX/w;
    [self changeTabSelected:_selectedTaskIndex];
    [self getCurrentdisplayTaskListView:_selectedTaskIndex];
    [self.tabToolView layoutIfNeeded];
}

#pragma mark - public

- (void)setChildrenViewList:(NSArray *)listView{
    [self.taskListViewArray addObjectsFromArray:listView];
    
    [self addSubview:self.tabToolView];
    [self.tabToolView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(44);
    }];
    [self addSubview:self.searchView];
    [self.searchView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabToolView.mas_bottom);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(self.listType == 1 ? 64:0.01);
    }];
    [self addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom);
        make.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.scrollView addSubview:self.contentView];

    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    __block UIView *list = nil;
    __block UIButton *tabButton = nil;
    for (int i = 0; i< listView.count; i++) {
        // 添加控制器
        TaskListView *taskListView = (TaskListView *)listView[i];
        UIView *bgView = [[UIView alloc] init];
        [bgView addSubview:taskListView];
        [self.contentView addSubview:bgView];
        [taskListView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.bottom.equalTo(-15);
            make.left.equalTo(15);
            make.right.equalTo(-15);
        }];
        // 添加切换按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:taskListView.listTitle forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [button setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
        [button setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateSelected];
        [self.tabToolView addSubview:button];
        button.tag = i+10000;
        
        [button addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabButtonArray addObject:button];
        // tab
        [button makeConstraints:^(MASConstraintMaker *make) {
            if (tabButton == nil) {
                make.left.equalTo(self.tabToolView);
            }else{
                make.left.equalTo(tabButton.mas_right);
            }
            make.top.bottom.equalTo(self.tabToolView);
            make.width.equalTo(kScreenWidth/listView.count);
            if (i == listView.count) {
                make.right.equalTo(self.tabToolView);
            }
        }];
        tabButton = button;
        // list
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.width.equalTo(self.scrollView);

            if (list) {
                make.left.equalTo(list.mas_right);
            }else{
                make.left.equalTo(0);
            }
        }];
        list = bgView;
    }
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(list.mas_right);
    }];
    
    // line
    [self.tabToolView addSubview:self.lineView];
    
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.bottom.equalTo(self.tabToolView);
        make.height.equalTo(2);
        make.width.equalTo(kScreenWidth/listView.count);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [SZUtil colorWithHex:@"#057DFF"];
    [self.lineView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.lineView).multipliedBy(0.5);
        make.center.equalTo(self.lineView);
        make.height.equalTo(self.lineView);
    }];
}

#pragma mark - Action
- (void)changeTab:(UIButton *)button{
    if (button.tag == self.selectedTaskIndex) {
        return;
    }
    self.selectedTaskIndex = button.tag - 10000;
}

- (void)setSelectedTaskIndex:(NSInteger)selectedTaskIndex{
    if (selectedTaskIndex == NSNotFound) {
        return;
    }
    _selectedTaskIndex = selectedTaskIndex;
    [self.scrollView setContentOffset:CGPointMake(_selectedTaskIndex*CGRectGetWidth(self.scrollView.frame),0) animated:YES];
    [self getCurrentdisplayTaskListView:_selectedTaskIndex];
}

- (void)changeTabSelected:(NSInteger)index{
    for (UIButton *button in self.tabButtonArray) {
        button.selected = button.tag == index + 10000;
    }
    [self routerEventWithName:form_tab_type userInfo:@{@"index":@(index)}];
}
// 获取当前显示的tasklist 并且reloaddata
- (void)getCurrentdisplayTaskListView:(NSInteger)index{
    TaskListView *currentListView = self.taskListViewArray[index];
    [currentListView reloadDataFromNetwork];
}
#pragma mark - setter and getter

- (UIView *)tabToolView{
    if (_tabToolView == nil) {
        _tabToolView = [[UIView alloc] init];
    }
    return _tabToolView;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}
- (TaskSearchView *)searchView{
    if (_searchView == nil) {
        _searchView = [[TaskSearchView alloc] init];
    }
    return _searchView;
}
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled =YES;
        _scrollView.delegate = self;
    }
    return _scrollView;;
}
- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  TabListView.m
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import "TabListView.h"
#import "TaskListView.h"

@interface TabListView ()<UIScrollViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UIView *tabToolView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISearchBar *searchBar;

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
    self.searchBar.text = @"";
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate == NO){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat w = CGRectGetWidth(self.frame);
    _selectedTaskIndex = offsetX/w;
    self.searchBar.text = @"";
    [self changeTabSelected:_selectedTaskIndex];
    [self getCurrentdisplayTaskListView:_selectedTaskIndex];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self updateSearchBarViewLayout:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self getCurrentdisplayTaskListView:_selectedTaskIndex];
    [self updateSearchBarViewLayout:NO];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索");
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self updateSearchBarViewLayout:NO];
    [self getCurrentdisplayTaskListView:_selectedTaskIndex];
}

- (void)updateSearchBarViewLayout:(BOOL)show{
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3 animations:^{
             [self.searchBar updateConstraints:^(MASConstraintMaker *make) {
                 make.top.equalTo(self.tabToolView.mas_bottom).offset(show== YES ? -44:0);

             }];
            [self layoutIfNeeded];
      }];
}
#pragma mark - public

- (void)setChildrenViewList:(NSArray *)listView{
    [self.taskListViewArray addObjectsFromArray:listView];
    
    [self addSubview:self.tabToolView];
    [self.tabToolView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(44);
    }];
    [self addSubview:self.searchBar];
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabToolView.mas_bottom);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(self.listType == 1 ? 64:0.01);
    }];
    [self addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom);
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
    [self changeTabSelected:_selectedTaskIndex];
}

- (void)setSelectedTaskIndex:(NSInteger)selectedTaskIndex{
    if (selectedTaskIndex == NSNotFound) {
        return;
    }
    _selectedTaskIndex = selectedTaskIndex;
    [self.scrollView setContentOffset:CGPointMake(_selectedTaskIndex*CGRectGetWidth(self.scrollView.frame),0) animated:YES];
    self.searchBar.text = @"";
    [self getCurrentdisplayTaskListView:_selectedTaskIndex];
    [self changeTabSelected:_selectedTaskIndex];
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
    [currentListView searchTask:self.searchBar.text];
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
- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索任务";
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = NO;
//        _searchBar.showsSearchResultsButton = YES;
        _searchBar.showsBookmarkButton = YES;
    }
    return _searchBar;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

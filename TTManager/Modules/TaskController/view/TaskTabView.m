//
//  TaskTabView.m
//  TTManager
//
//  Created by chao liu on 2020/12/29.
//

#import "TaskTabView.h"
#import "TaskListView.h"

@interface TaskTabView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *tabToolView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *lastSelectedButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *contentView;

@end

@implementation TaskTabView

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.x;
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat x = w/4/w*offsetY;
    [self.lineView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(x);
    }];
    [self.tabToolView layoutIfNeeded];
}

#pragma mark - public

- (void)setChildrenViewList:(NSArray *)listView
{
    [self addSubview:self.tabToolView];
    [self.tabToolView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(44);
    }];
    
    [self addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
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
        [button setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
        [button setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateSelected];
        [self.tabToolView addSubview:button];
        button.tag = i;
        if (i == 0) {
            self.lastSelectedButton = button;
            button.selected = YES;
        }
        [button addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
        // tab
        [button makeConstraints:^(MASConstraintMaker *make) {
            if (tabButton == nil) {
                make.left.equalTo(self.tabToolView);
            }else{
                make.left.equalTo(tabButton.mas_right);
            }
            make.top.bottom.equalTo(self.tabToolView);
            make.width.equalTo(kScreenWidth/4);
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
        make.width.equalTo(kScreenWidth/4);
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
    self.lastSelectedButton.selected = NO;
    button.selected = YES;
    self.lastSelectedButton = button;
    [self.scrollView setContentOffset:CGPointMake(button.tag*CGRectGetWidth(self.scrollView.frame),0) animated:YES];
}

#pragma amrk - setter and getter
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  ZHCalendarView.m
//  TTManager
//
//  Created by chao liu on 2021/1/7.
//

#import "ZHCalendarView.h"
#import "CalendarLogic.h"
#import "CalendarDayModel.h"
#import "CalendarDayCell.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarMonthCollectionViewLayout.h"
#import "ZHCalendarHeaderView.h"

static NSString *MonthHeader = @"MonthHeaderView";
static NSString *DayCell = @"DayCell";

#define CATDayLabelHeight 30.0f
#define DefaultEmptyViewHeight 110.0f

@interface ZHCalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView* collectionView;//网格视图
@property (nonatomic ,strong) NSMutableArray *calendarMonth;//每个月份的中的daymodel容器数组
@property (nonatomic ,strong) CalendarLogic *Logic;
@property (nonatomic, strong) NSIndexPath *lastSelecteIndexPath;

@end

@implementation ZHCalendarView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatUI];
        self.lastSelecteIndexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:NSNotFound];
        self.backgroundColor = RGBA_COLOR(0, 0, 0, 0.7);
    }
    return self;
}
- (NSMutableArray *)calendarMonth
{
    if (_calendarMonth == nil){
        _calendarMonth = [NSMutableArray array];
    }
    return _calendarMonth;
}
- (void)needMonth:(NSUInteger)month
{
    if (self.calendarMonth.count <=0)
        self.calendarMonth = [self.Logic reloadCalendarView:[NSDate date] needMonth:month];
    
    [self.collectionView reloadData];
}
- (CalendarLogic *)Logic
{
    if (_Logic == nil){
        _Logic = [[CalendarLogic alloc] init];
    }
    return _Logic;
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];
        [_collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)creatUI
{
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    ZHCalendarHeaderView *headerView = [[ZHCalendarHeaderView alloc] init];
    [bgView addSubview:headerView];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(self).multipliedBy(0.7);
    }];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    [bgView layoutIfNeeded];
    [headerView addCornerRadiu];
    [bgView addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.bottom.right.equalTo(0);
    }];
    __weak typeof(self) weakSelf = self;
    headerView.closeBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showCalendarView:NO];
    };
    headerView.sureBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showCalendarView:NO];
    };
}
#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
}
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
    return monthArray.count;
}
//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = model;
    return cell;
}
// 头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        CalendarDayModel *model = [month_Array objectAtIndex:15];
        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%lu年 %lu月",(unsigned long)model.year,(unsigned long)model.month];//@"日期";
//        monthHeader.backgroundColor = RGB_COLOR(44, 44, 44);
        reusableview = monthHeader;
    }
    return reusableview;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    
    if (model.style != CellDayTypeEmpty
        && model.style != CellDayTypePast && model.style != CellDayTypeWeek){
        self.lastSelecteIndexPath = indexPath;
        [self.collectionView reloadData];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(ZHCalendarViewDidSelectedDate:end:totalDays:)]) {
//            [self.delegate ZHCalendarViewDidSelectedDate:model end:model totalDays:3];
//        }
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)setLastSelecteIndexPath:(NSIndexPath *)lastSelecteIndexPath{
    if (lastSelecteIndexPath.row == NSNotFound) {
        return;
    }
    if (_lastSelecteIndexPath != lastSelecteIndexPath) {
        CalendarDayModel *lastDayModel = [self getLastSelecteDayModel:_lastSelecteIndexPath];
        _lastSelecteIndexPath = lastSelecteIndexPath;
        CalendarDayModel *currentDayModel = [self getLastSelecteDayModel:_lastSelecteIndexPath];
        lastDayModel.currentClick = NO;
        currentDayModel.currentClick = YES;
    }
}
- (CalendarDayModel *)getLastSelecteDayModel:(NSIndexPath *)indexPath{
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    return model;
}
// 充值选择的日期
- (void)remakeSelectedDate{
    
}
- (void)showCalendarView:(BOOL)show
{
    CGRect showFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    CGRect hideFrame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = show == YES ? showFrame : hideFrame;
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

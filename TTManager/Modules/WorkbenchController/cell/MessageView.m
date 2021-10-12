//
//  MessageView.m
//  TTManager
//
//  Created by chao liu on 2020/12/28.
//

#import "MessageView.h"
#import "MsgFooterView.h"

@interface MessageView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MessageView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        [self layoutTableView];
    }
    return self;
}
- (void)layoutTableView{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(20);
        make.bottom.equalTo(-20);
    }];
}
- (void)setMessageArray:(NSArray *)messageArray{
    if (_messageArray != messageArray) {
        _messageArray = messageArray;
        [self.tableView showDataCount:_messageArray.count type:3];
        [self.tableView reloadData];
    }
}
#pragma mark -UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.messageArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    id data = self.messageArray[section];
    if ([data isKindOfClass:[NSString class]]){
        return 0.01;
    }
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MsgFooterView *view = (MsgFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    id data = self.messageArray[section];
    if (![data isKindOfClass:[NSString class]]){
        view.memo = self.messageArray[section];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = @"";
    id data = self.messageArray[indexPath.section];
    if ([data isKindOfClass:[NSString class]])
    {
        name = (NSString *)name;
    }else if([data isKindOfClass:[ZHProjectMemo class]]){
        ZHProjectMemo *memo = (ZHProjectMemo *)data;
        name = memo.line;
    }
    CGFloat textHeight = [NSString heightFromString:name withFont:[UIFont systemFontOfSize:14.0f] constraintToWidth:self.frame.size.width-40];
    return textHeight < 30 ? 40:textHeight+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    id data = self.messageArray[indexPath.section];
    cell.textLabel.numberOfLines = 0;
    cell.imageView.image = [UIImage imageNamed:@"delete_password"];
    if ([data isKindOfClass:[NSString class]])
    {
        cell.textLabel.text = (NSString *)data;
        cell.textLabel.textColor = [UIColor whiteColor];
    }else if([data isKindOfClass:[ZHProjectMemo class]]){
        ZHProjectMemo *memo = (ZHProjectMemo *)data;
        cell.textLabel.text = memo.line;
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MsgFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

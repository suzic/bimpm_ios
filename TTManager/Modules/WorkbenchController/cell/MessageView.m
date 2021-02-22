//
//  MessageView.m
//  TTManager
//
//  Created by chao liu on 2020/12/28.
//

#import "MessageView.h"

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
        make.bottom.equalTo(20);
    }];
}
- (void)setMessageArray:(NSArray *)messageArray{
    if (_messageArray != messageArray) {
        _messageArray = messageArray;
        [self.tableView showDataCount:_messageArray.count type:0];
        [self.tableView reloadData];
    }
}
#pragma mark -UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = @"";
    id data = self.messageArray[indexPath.row];
    if ([data isKindOfClass:[NSString class]])
    {
        name = (NSString *)name;
    }else if([data isKindOfClass:[ZHProjectMemo class]]){
        ZHProjectMemo *memo = (ZHProjectMemo *)data;
        name = memo.line;
    }
    CGFloat textHeight = [NSString heightFromString:name withFont:[UIFont systemFontOfSize:14.0f] constraintToWidth:self.frame.size.width];
    return textHeight < 30 ? 30:textHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    id data = self.messageArray[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.imageView.image = [UIImage imageNamed:@"delete_password"];
    if ([data isKindOfClass:[NSString class]])
    {
        cell.textLabel.text = (NSString *)data;
        cell.textLabel.textColor = [UIColor whiteColor];
    }else if([data isKindOfClass:[ZHProjectMemo class]]){
        ZHProjectMemo *memo = (ZHProjectMemo *)data;
        cell.textLabel.text = memo.line;
        cell.textLabel.textColor = [SZUtil colorWithHex:@"#333333"];
        cell.detailTextLabel.text = [SZUtil getTimeString:memo.edit_date];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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

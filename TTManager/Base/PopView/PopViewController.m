//
//  PopViewController.m
//  KeyChain
//
//  Created by 刘超 on 16/1/7.
//  Copyright © 2016年 Lc. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation PopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    [self addTableViewMasonryLayout];
}

- (void)addTableViewMasonryLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.width.equalTo(self.view);
        make.bottom.equalTo(20);
        make.left.right.equalTo(self.view);
    }];
}
- (void)setDataList:(NSArray *)dataList{
    if (_dataList != dataList)
    {
        _dataList = dataList;
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    for (UIView *view in cell.contentView.subviews)
         [view removeFromSuperview];
    id dataItem = self.dataList[indexPath.row];
    if ([dataItem isKindOfClass:[ZHProject class]]) {
        
        if (indexPath.row == self.dataList.count)
        {
            cell.textLabel.text = self.dataList[indexPath.row];
        }else{
            ZHProject *project = (ZHProject *)dataItem;
            cell.textLabel.text = project.name;
        }
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataList[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate popViewControllerSelectedCellIndexContent:indexPath];
    }];
}



//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize
{
    if (self.presentingViewController && self.tableView != nil)
    {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 200;
        //sizeThatFits返回的是最合适的尺寸，但不会改变控件的大小
        CGSize size = [self.tableView sizeThatFits:tempSize];
        return size;
    }else
    {
        return [super preferredContentSize];
    }
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize
{
    super.preferredContentSize = preferredContentSize;
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

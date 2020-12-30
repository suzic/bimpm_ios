//
//  PopViewController.h
//  KeyChain
//
//  Created by 刘超 on 16/1/7.
//  Copyright © 2016年 Lc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PopViewSelectedIndexDelegate <NSObject>

- (void)popViewControllerSelectedCellIndexContent:(NSIndexPath *)indexPath;

@end

@interface PopViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) id<PopViewSelectedIndexDelegate>delegate;
@end

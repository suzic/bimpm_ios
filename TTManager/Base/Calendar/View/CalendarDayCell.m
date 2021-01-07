//
//  CalendarDayCell.m
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarDayCell.h"

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    //选中时显示的图片
    imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/7, kScreenWidth/7)];
    imgview.image = [SZUtil createImageWithColor:RGBA_COLOR(5, 125, 255, 1.0)];
    imgview.clipsToBounds = YES;
    imgview.layer.cornerRadius =kScreenWidth/7/2;
    [self addSubview:imgview];
    
    //日期
    day_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    [self addSubview:day_lab];

    //农历
    day_title = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 13)];
    day_title.textColor = [UIColor whiteColor];
    day_title.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    day_title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:day_title];
}

- (void)setModel:(CalendarDayModel *)model
{
    _model = model;
    switch (model.style)
    {
        case CellDayTypeEmpty://不显示
            [self hidden_YES];
            day_title.text = @"";
            break;
            
        case CellDayTypePast://过去的日期
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            day_lab.textColor = [UIColor grayColor];
            imgview.hidden = YES;
            day_title.text = @"";
            break;
            
        case CellDayTypeFutur://将来的日期
            [self hidden_NO];
            if ([model currentModelIsToday:model])
                day_lab.text = @"今天";
            else
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];

            day_lab.textColor = [SZUtil colorWithHex:@"#333333"];
            imgview.hidden = !model.currentClick;
            day_title.text = @"";
            break;
            
        case CellDayTypeWeek://周末
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            day_lab.textColor = [UIColor redColor];
            imgview.hidden = YES;
            day_title.text = @"";
            break;
        default:
            break;
    }
}

- (void)hidden_YES
{
    day_lab.hidden = YES;
    day_title.hidden = YES;
    imgview.hidden = YES;
    
}

- (void)hidden_NO
{
    day_lab.hidden = NO;
    day_title.hidden = NO;
}


@end

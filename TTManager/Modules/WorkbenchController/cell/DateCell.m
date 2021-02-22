//
//  DateCell.m
//  TTManager
//
//  Created by chao liu on 2021/2/22.
//

#import "DateCell.h"

@implementation DateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setCurrentDate];
}

- (void)setCurrentDate{
    self.timeInforLabel.hidden = NO;
    self.timeLabel.text = [SZUtil getDateString:[NSDate date]];
    NSDate *date = [NSDate date];
    Solar *solarDate = [[Solar alloc] initWithDate:date];
    Lunar *lunarDate = solarDate.lunar;
    self.timeInforLabel.text = [NSString stringWithFormat:@"%@%@%@",[lunarDate ganzhiYear],lunarDate.lunarFromatterMonth, lunarDate.lunarFomatterDay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MonitoringCell.m
//  TTManager
//
//  Created by chao liu on 2021/1/21.
//

#import "MonitoringCell.h"

@implementation MonitoringCell

- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width/2;
    [self.contentView borderForColor:[UIColor groupTableViewBackgroundColor] borderWidth:0.5 borderType:UIBorderSideTypeAll];
}

@end

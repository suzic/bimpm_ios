//
//  UIView+BorderLine.m
//  TTManager
//
//  Created by chao liu on 2020/12/27.
//

#import "UIView+BorderLine.h"

static void *HUD = @"HUD";


@interface UIView ()

@property (nonatomic, strong) UIActivityIndicatorView *hud;

@end

@implementation UIView (BorderLine)
- (UIView *)borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType
{
    if (borderType == UIBorderSideTypeAll)
    {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = color.CGColor;
        return self;
    }
    /// 左侧
    if (borderType & UIBorderSideTypeLeft) {
        /// 左侧线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.f, 0.f) toPoint:CGPointMake(0.0f, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
      
    /// 右侧
    if (borderType & UIBorderSideTypeRight) {
        /// 右侧线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(self.frame.size.width, 0.0f) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
      
    /// top
    if (borderType & UIBorderSideTypeTop) {
        /// top线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(self.frame.size.width, 0.0f) color:color borderWidth:borderWidth]];
    }
      
    /// bottom
    if (borderType & UIBorderSideTypeBottom) {
        /// bottom线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, self.frame.size.height) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
    return self;
}

- (CAShapeLayer *)addLineOriginPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p0];
    [bezierPath addLineToPoint:p1];
      
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    return shapeLayer;
}

- (void)startActivityIndicatorView{
    [self initHUD];
    BOOL mainThread = [NSThread isMainThread];
    if (mainThread == NO)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.hud) {
                [self.hud startAnimating];
                self.hud.hidden = NO;
            }
        });
    }else{
        if (self.hud) {
            [self.hud startAnimating];
            self.hud.hidden = NO;
        }
    }
}

- (void)stopActivityIndicatorView{
    BOOL mainThread = [NSThread isMainThread];
   if (mainThread == YES){
       [self.hud stopAnimating];
       self.hud.hidden = YES;
   }else
   {
       dispatch_sync(dispatch_get_main_queue(), ^{
           [self.hud stopAnimating];
           self.hud.hidden = YES;
       });
   }
}

- (MBProgressHUD *)hud{
    return objc_getAssociatedObject(self, HUD);
}

- (void)setHud:(UIActivityIndicatorView *)hud{
    objc_setAssociatedObject(self, HUD, hud, OBJC_ASSOCIATION_RETAIN);
}
- (void)initHUD{
    if (!self.hud) {
//         = [[MBProgressHUD alloc] initWithView:self];
        self.hud = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.width-10, (self.height-10)/2, 10, 10)];
//        self.hud.frame = CGRectMake(0, 0, 10, 10);
//        self.hud.center = self.center;
//        self.hud.style = MBProgressHUDBackgroundStyleSolidColor;
//        self.hud.bezelView.backgroundColor = RGBA_COLOR(0, 0, 0, 0.5);
        [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
        [self addSubview:self.hud];
    }else{
        [self.hud stopAnimating];
    }
}
@end

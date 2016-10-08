//
//  PieView.m
//  DrowRect-OC
//
//  Created by fans on 16/10/8.
//  Copyright © 2016年 Fans. All rights reserved.
//

#import "PieView.h"

#define kAnimationDuration 2.0f
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kPieBackgroundColor [UIColor grayColor]
#define kPieFillColor [UIColor clearColor].CGColor
#define kPieRandColor [UIColor colorWithRed:arc4random() % 255 / 255.0f green:arc4random() % 255 / 255.0f blue:arc4random() % 255 / 255.0f alpha:1.0f]
#define kLabelLocationRatio (1.2*bgRadius)

@interface PieView ()
@property (nonatomic) CGFloat total;
@property (nonatomic) CAShapeLayer *bgCircleLayer;

@end

@implementation PieView

- (instancetype)initWithFrame:(CGRect)frame dataItems:(NSArray *)dataItems colorItems:(NSArray *)colorItems
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView:frame dataItems:dataItems colorItems:colorItems];
    }
    return self;
}

- (void)makeView:(CGRect)frame dataItems:(NSArray *)dataItems colorItems:(NSArray *)colorItems{
    self.hidden = YES;
    self.backgroundColor = kPieBackgroundColor;
    // 1. pieView center point
    CGFloat centerWidth = self.frame.size.width * 0.5f;
    CGFloat centerHeight = self.frame.size.height * 0.5f;
    CGFloat centerX = centerWidth;
    CGFloat centerY = centerHeight;
    CGPoint centerPoint = CGPointMake(centerX , centerY);
    CGFloat radiusBasic = centerHeight > centerWidth ? centerWidth : centerHeight;

    // 计算 colors 角度总和
    _total = 0.0f;
    for (int i=0; i<dataItems.count; i++) {
        _total += [dataItems[i] floatValue];
    }

    //线的半径为扇形半径的一半，线宽是扇形半径，这样就能画出圆形了
    // 2. 背景路径
    CGFloat bgRadius = radiusBasic * 0.5;
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                          radius:bgRadius
                                                      startAngle:-M_PI_2
                                                        endAngle:M_PI_2 * 3
                                                       clockwise:YES];
    _bgCircleLayer = [CAShapeLayer layer];
    _bgCircleLayer.fillColor = kPieFillColor;
    _bgCircleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _bgCircleLayer.strokeStart = 0.0f;
    _bgCircleLayer.strokeEnd = 1.0f;
    _bgCircleLayer.zPosition = 1;
    _bgCircleLayer.lineWidth = bgRadius * 2.0f;
    _bgCircleLayer.path = bgPath.CGPath;

    // 3. 子扇路径
    CGFloat otherRadius = radiusBasic * 0.5 - 3.0;
    UIBezierPath *otherPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                             radius:otherRadius
                                                         startAngle:-M_PI_2
                                                           endAngle:M_PI_2 * 3
                                                          clockwise:YES];
    CGFloat start = 0.0f;
    CGFloat end = 1.0f;
    for (int i = 0; i< dataItems.count; i++) {
        //4. 计算当前end位置 = 上一个结束位置 + 当前部分百分比
        end = [dataItems[i] floatValue] / _total + start;

        //图层
        CAShapeLayer *pie = [CAShapeLayer layer];
        [self.layer addSublayer:pie];
        pie.fillColor = kPieFillColor;
        if (i > colorItems.count-1 || !colorItems || colorItems.count == 0) {
            //如果传过来的颜色数组少于item个数则随机填充颜色
            pie.strokeColor = kPieRandColor.CGColor;
        }else{
            pie.strokeColor = ((UIColor*)colorItems[i]).CGColor;
        }

        pie.strokeStart = start;
        pie.strokeEnd = end;
        pie.lineWidth = otherRadius * 2.0f;
        pie.zPosition = 2;
        pie.path = otherPath.CGPath;

        // 计算百分比label的位置
        CGFloat centerAngle = M_PI * (start + end);
        CGFloat labelCenterX = kLabelLocationRatio*sinf(centerAngle) + centerX;
        CGFloat labelCenterY = -kLabelLocationRatio*cosf(centerAngle) + centerY;
        CGFloat labelEdge = 0.5f;
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, radiusBasic * labelEdge, radiusBasic * labelEdge)];
        label.center = CGPointMake(labelCenterX, labelCenterY);
        label.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)((end - start + 0.005) * 100)];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.zPosition = 3;
        [self addSubview:label];

        //计算下一个
        start = end;

    }
    self.layer.mask = _bgCircleLayer;
}
- (void)stroke{
    self.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = kAnimationDuration;
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = YES;
    [_bgCircleLayer addAnimation:animation forKey:@"circleAnimation"];
}
- (void)dealloc
{
    [self.layer removeAllAnimations];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end

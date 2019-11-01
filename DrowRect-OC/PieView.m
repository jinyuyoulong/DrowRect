//
//  PieView.m
//  DrowRect-OC
//
//  Created by fans on 16/10/8.
//  Copyright © 2016年 Fans. All rights reserved.
//

#import "PieView.h"
#import "NSString+Handler.h"

#define SCREENT_WIDTH [[UIScreen mainScreen] bounds].size.width

#define kAnimationDuration 2.0f
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kPieBackgroundColor [UIColor grayColor]
#define kPieFillColor [UIColor clearColor].CGColor
#define kPieRandColor [UIColor colorWithRed:arc4random() % 255 / 255.0f green:arc4random() % 255 / 255.0f blue:arc4random() % 255 / 255.0f alpha:1.0f]
#define kLabelLocationRatio (1.2*bgRadius)

typedef enum : NSUInteger {
    AngleTypeRightUp,
    AngleTypeRightDown,
    AngleTypeLeftDown,
    AngleTypeLeftUp,
    AngleTypeTemp
} AngleType;

@interface PieView ()
@property (nonatomic) CGFloat total;
@property (nonatomic) CAShapeLayer *bgCircleLayer;
@property (nonatomic, strong) UIView *bgView;
@end


/**
 m file 哈哈哈哈哈s 不管用，不会提现在文档上
 */
@implementation PieView

- (instancetype)initWithFrame:(CGRect)frame dataItems:(NSArray *)dataItems colorItems:(NSArray *)colorItems
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView:frame dataItems:dataItems colorItems:colorItems];
    }
    return self;
}

- (instancetype)initWithDataItems:(NSArray *)dataItems titles:(NSArray *)titles colorItems:(NSArray *)colorItems
{
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/2+120);
         _titles = titles;
        [self makeView2:frame dataItems:dataItems colorItems:colorItems];
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
        label.text = [NSString stringWithFormat:@"%ld%%",(long)((end - start + 0.005) * 100)];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.zPosition = 3;
        [self addSubview:label];

        //计算下一个
        start = end;

    }
    self.layer.mask = _bgCircleLayer;
}

- (void)makeView2:(CGRect)frame dataItems:(NSArray*)dataItems colorItems:(NSArray *)colorItems
{
    
    self.hidden = YES;
    self.bgView = [[UIView alloc] initWithFrame:frame];
    
    [self addSubview:_bgView];
    
    // 1. pieView center point
    CGFloat centerWidth = frame.size.width * 0.5f;
    CGFloat centerHeight = frame.size.height * 0.5f;
    CGFloat centerX = centerWidth;
    CGFloat centerY = centerHeight;
    CGPoint centerPoint = CGPointMake(centerX , centerY);
    CGFloat radiusBasic = 0.5 * centerWidth;
    
    // 计算 colors 角度总和
    _total = 0.0f;
    for (int i=0; i<dataItems.count; i++) {
        double datai = [NSString stringWithFormat:@"%@",dataItems[i]].trimSemicolon.doubleValue;
        _total += datai;
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
    
    // 所有数据为0
    if (dataItems.count == 0 || _total == 0){
        [self makeHalfCircleView:centerPoint redius:bgRadius];
        CGFloat miniRadius = (4.0/9.0) * bgRadius;
        [self makeOneCircleView:centerPoint redius:miniRadius color:[UIColor whiteColor]];
        [self stroke];
        return;
    }
    
    // 3. 子扇路径
    UIBezierPath *otherPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                             radius:bgRadius
                                                         startAngle:-M_PI_2
                                                           endAngle:M_PI_2 * 3
                                                          clockwise:YES];
    CGFloat start = 0.0f;
    CGFloat end = 1.0f;
    for (int i = 0; i< dataItems.count; i++) {
        //4. 计算当前end位置 = 上一个结束位置 + 当前部分百分比
        double datai = [NSString stringWithFormat:@"%@",dataItems[i]].trimSemicolon.doubleValue;
        
        end = datai / _total + start;
        
        //图层
        CAShapeLayer *pie = [CAShapeLayer layer];
        [_bgView.layer addSublayer:pie];
        pie.fillColor = kPieFillColor;
        if (i > colorItems.count-1 || !colorItems || colorItems.count == 0) {
            //如果传过来的颜色数组少于item个数则随机填充颜色
            pie.strokeColor = kPieRandColor.CGColor;
        }else{
            pie.strokeColor = ((UIColor*)colorItems[i]).CGColor;
        }
        
        pie.strokeStart = start;
        pie.strokeEnd = end;
        pie.lineWidth = 2*bgRadius;
        pie.zPosition = 2;
        pie.path = otherPath.CGPath;
        
        // 计算注释的位置
        CGFloat pointRadius = 2*bgRadius+5;
        CGFloat angle = M_PI * (start + end);
        CGFloat lineCenterX = pointRadius * sinf(angle) + centerPoint.x;
        CGFloat lineCenterY = -pointRadius * cosf(angle) + centerPoint.y;
        CGPoint  startPoint = CGPointMake(lineCenterX, lineCenterY);
        
        [self makePointLayer:startPoint color:colorItems[i]];
        
        AngleType angleType;
        
        if (angle < M_PI) {
            if (angle < M_PI_2) {
                angleType = AngleTypeRightUp;
            }else{
                angleType = AngleTypeRightDown;
            }
        }else{
            if (angle < ( M_PI * 1.5)) {
                angleType = AngleTypeLeftDown;
            }else{
                angleType = AngleTypeLeftUp;
            }
            
        }
        
        double twoScale = 1;
        
        if (i>0) {
            double datai_1 = [NSString stringWithFormat:@"%@", dataItems[i-1]].trimSemicolon.doubleValue;
            double datai = [NSString stringWithFormat:@"%@",dataItems[i]].trimSemicolon.doubleValue;
            twoScale = (datai_1 + datai)/ _total;
        }
        CGFloat lineY = 15;
        
        if (twoScale < 0.25) {
            //            angleType += 1;
            //            if (angleType == AngleTypeTemp) {
            //                angleType = AngleTypeRightUp;
            //            }
            
            lineY = 15+ 35;
        }
        
        CALayer * lineLayer = [self makeLineLayer:startPoint
                                             type:angleType
                                            color:colorItems[i]
                                            title:_titles[i]
                                              num: dataItems[i]
                                            lineY:lineY];
        
        [self.layer addSublayer:lineLayer];
        
        //计算下一个
        start = end;
    }
    CGFloat miniRadius = (4.0/9.0) * bgRadius;
    [self makeOneCircleView:centerPoint redius:miniRadius color:[UIColor whiteColor]];
    
    _bgView.layer.mask = _bgCircleLayer;
    [self stroke];
}
- (void)makePointLayer:(CGPoint)startP color:(UIColor*) color{
    UIBezierPath * pointPath = [UIBezierPath bezierPathWithArcCenter:startP
                                                              radius:2
                                                          startAngle:0
                                                            endAngle:(M_PI * 2)
                                                           clockwise:YES];
    CAShapeLayer * pointLayer = [CAShapeLayer layer];
    pointLayer.path = pointPath.CGPath;
    pointLayer.fillColor = color.CGColor;
    pointLayer.strokeColor = color.CGColor;
    pointLayer.lineWidth = 1;
    [self.layer addSublayer:pointLayer];
}

- (CALayer*)makeLineLayer:(CGPoint)startP type:(AngleType)type color:(UIColor*) color title:(NSString*)title num:(NSString*)num lineY:(CGFloat) line_y{
    CALayer *layer = [CALayer layer];
    
    UIBezierPath * pointPath = [UIBezierPath bezierPath];
    CGPoint toPoint;
    CGPoint endPoint;
    float lineX = 15;
    float lineY = line_y;
    
    switch (type) {
        case AngleTypeRightUp:
            toPoint = CGPointMake(startP.x+lineX, startP.y-lineY);
            endPoint = CGPointMake(SCREENT_WIDTH-15, toPoint.y);
            break;
        case AngleTypeRightDown:
            toPoint = CGPointMake(startP.x+lineX, startP.y+lineY);
            endPoint = CGPointMake(SCREENT_WIDTH-15, toPoint.y);
            break;
        case AngleTypeLeftDown:
            toPoint = CGPointMake(startP.x-lineX, startP.y+lineY);
            endPoint = CGPointMake(15, toPoint.y);
            break;
        case AngleTypeLeftUp:
            toPoint = CGPointMake(startP.x-lineX, startP.y-lineY);
            endPoint = CGPointMake(15, toPoint.y);
            break;
        default:
            toPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(0, 0);
            break;
    }
    [pointPath moveToPoint:startP];
    [pointPath addLineToPoint:toPoint];
    [pointPath addLineToPoint:endPoint];
    
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.path = pointPath.CGPath;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.lineWidth = 1;
    
    [self.layer addSublayer:lineLayer];
    
    [self  makeDescribeLabel:toPoint type:type title:title num:num];
    
    return layer;
}
- (void)makeDescribeLabel:(CGPoint)startP type:(AngleType)type title:(NSString*)title num:(NSString*)num {
    UILabel * numberlab1 = [[UILabel alloc] init];
    numberlab1.text =  num;
    [self addSubview:numberlab1];
    UILabel * lab2 = [[UILabel alloc] init];
    lab2.text = title;
    [self addSubview:lab2];
    CGRect numfram;
    CGRect labFram;
    float labWidth = 100;
    float labHeight = 20;
    
    switch (type) {
        case AngleTypeRightUp:
            numfram = CGRectMake(SCREENT_WIDTH-labWidth-15, startP.y - 20, labWidth, labHeight);
            labFram = CGRectMake(SCREENT_WIDTH-labWidth-15, startP.y, labWidth, labHeight);
            [self makeLabelTextAlignment:numberlab1 lab2:lab2 textAli:NSTextAlignmentRight];
            break;
        case AngleTypeRightDown:
            labFram = CGRectMake(SCREENT_WIDTH-labWidth-15, startP.y - 20, labWidth, labHeight);
            numfram = CGRectMake(SCREENT_WIDTH-labWidth-15, startP.y, labWidth, labHeight);
            [self makeLabelTextAlignment:numberlab1 lab2:lab2 textAli:NSTextAlignmentRight];
            break;
        case AngleTypeLeftDown:
            labFram = CGRectMake(15, startP.y-20, labWidth, labHeight);
            numfram = CGRectMake(15, startP.y, labWidth, labHeight);
            [self makeLabelTextAlignment:numberlab1 lab2:lab2 textAli:NSTextAlignmentLeft];
            
            break;
        case AngleTypeLeftUp:
            numfram = CGRectMake(15, startP.y - 20, labWidth, labHeight);
            labFram = CGRectMake(15, startP.y, labWidth, labHeight);
            [self makeLabelTextAlignment:numberlab1 lab2:lab2 textAli:NSTextAlignmentLeft];
            break;
        default:
            numfram = CGRectMake(15, startP.y - 20, labWidth, labHeight);
            labFram = CGRectMake(15, startP.y, labWidth, labHeight);
            [self makeLabelTextAlignment:numberlab1 lab2:lab2 textAli:NSTextAlignmentLeft];
            break;
    }
    
    numberlab1.frame = numfram;
    lab2.frame = labFram;
    
}
- (void)makeLabelTextAlignment:(UILabel*)lab1 lab2:(UILabel*)lab2 textAli:(NSTextAlignment)textAli{
    lab1.textAlignment = textAli;
    lab2.textAlignment = textAli;
    lab1.font = [UIFont systemFontOfSize:12];
    lab2.font = [UIFont systemFontOfSize:12];
    lab1.textColor = [UIColor blackColor];
    lab2.textColor = [UIColor purpleColor];
}
- (void)makeHalfCircleView:(CGPoint)center redius:(CGFloat)redius{
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center radius:redius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor colorWithRed:198 green:198 blue:198 alpha:1].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = redius * 2;
    layer.strokeStart = 0;
    layer.strokeEnd = 1;
    layer.zPosition = 3;
    
    //    UIBezierPath * half_path = [UIBezierPath bezierPathWithArcCenter:center
    //                                                         radius:redius/2
    //                                                     startAngle:-M_PI_2
    //                                                       endAngle:M_PI_2*3
    //                                                      clockwise:YES];
    //
    //    CAShapeLayer * whiteCircle = [CAShapeLayer layer];
    //    whiteCircle.path = half_path.CGPath;
    //    whiteCircle.strokeColor = [UIColor whiteColor].CGColor;
    //    whiteCircle.fillColor = [UIColor whiteColor].CGColor;
    //    whiteCircle.lineWidth = redius;
    //    whiteCircle.strokeStart = 0;
    //    whiteCircle.strokeEnd = 1;
    //    layer.zPosition = 4;
    [_bgView.layer addSublayer:layer];
    //    [_bgView.layer addSublayer:whiteCircle];
}

- (void)makeOneCircleView:(CGPoint)center redius:(CGFloat)redius color:(UIColor*)color{
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center radius:redius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = color.CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = redius * 2;
    layer.strokeStart = 0;
    layer.strokeEnd = 1;
    layer.zPosition = 3;
    [_bgView.layer addSublayer:layer];
}
#pragma mark -
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

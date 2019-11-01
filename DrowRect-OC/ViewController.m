//
//  ViewController.m
//  DrowRect-OC
//
//  Created by fans on 16/10/8.
//  Copyright © 2016年 Fans. All rights reserved.
//

#import "ViewController.h"
#import "PieView.h"
#import "NSString+Handler.h"
#import "UIColor+Hex.h"

@interface ViewController ()
@property(nonatomic, strong)PieView *pie;
@property(nonatomic, strong)UILabel *labTotal;
@property(nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)NSMutableArray *datas;
@end

#define SCREENT_WIDTH [[UIScreen mainScreen] bounds].size.width

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSArray *colors = @[
//                        [UIColor redColor],
//                        [UIColor yellowColor],
//                        [UIColor blueColor]
//                        ];
//    CGRect frame = CGRectMake(0, 0, 200, 200);
//
//    _pie = [[PieView alloc] initWithFrame:frame dataItems:@[@4,@1,@5] colorItems:colors];
//
//    _pie.center = self.view.center;
//    [self.view addSubview:_pie];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, 50, SCREENT_WIDTH, 400);
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    [self initData];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_pie stroke];
}

- (void) initData{
    NSString *total = @"100";
    NSString *ttTxt = @"50";
    NSString *yyTxt = @"30";
    NSString *balance = @"20";
    
    _datas = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *colors = [NSMutableArray array];
    if([[ttTxt trimSemicolon] floatValue] != 0){
        [_datas addObject:ttTxt];
        [titles addObject:@"交通"];
        [colors addObject:[UIColor colorWithHexString:@"#7ECEF4"]];
    }
    if ([[yyTxt trimSemicolon] floatValue] != 0) {
        [_datas addObject:yyTxt];
        [titles addObject:@"日常"];
        [colors addObject:[UIColor colorWithHexString:@"#009fea"]];
    }
    if ([[balance trimSemicolon] floatValue] != 0) {
        [_datas addObject:balance];
        [titles addObject:@"房租"];
        [colors addObject:[UIColor lightGrayColor]];
    }
    [self makeCircleView:_datas colors:colors titles:titles];
    self.labTotal.text = total;
}


- (void)makeCircleView:(NSArray *)datas colors:(NSArray *)colors titles:(NSArray *)titles
{
    UILabel *totalTitle = [[UILabel alloc] init];
    totalTitle.text = @"总支出（元）";
    totalTitle.textAlignment = NSTextAlignmentCenter;
    totalTitle.font = [UIFont systemFontOfSize:12];
    totalTitle.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.bgView addSubview:totalTitle];
    
    [self.bgView addSubview:self.labTotal];
    
    PieView *circleView = [[PieView alloc] initWithDataItems:datas titles:titles colorItems:colors];
    circleView.backgroundColor = [UIColor whiteColor];
    
    
    [self.bgView addSubview:circleView];
    
    
    UIView *ttItem = [self makeBottomItem:@"tt_icon" text:@"天天趣"];
    [self.bgView addSubview:ttItem];
    UIView *yyItem = [self makeBottomItem:@"yy_icon" text:@"月月趣"];
    [self.bgView addSubview:yyItem];
    UIView *balanceItem = [self makeBottomItem:@"balance_icon" text:@"可用余额"];
    [self.bgView addSubview:balanceItem];
    
    totalTitle.frame = CGRectMake(0, 10, 100, 50);
    totalTitle.center = CGPointMake(self.bgView.center.x, totalTitle.center.y);

    _labTotal.frame = CGRectMake(0, totalTitle.frame.size.height+totalTitle.frame.origin.y+20, _labTotal.frame.size.width, _labTotal.frame.size.height);
    _labTotal.center = CGPointMake(self.bgView.center.x, _labTotal.center.y);
    
    circleView.frame = CGRectMake(0,0, SCREENT_WIDTH, SCREENT_WIDTH/2+120);
    circleView.center = self.bgView.center;

    
    CGFloat bottomOffset = 50;//80-halfRadius
    
    ttItem.frame = CGRectMake(15, [self bottom:circleView]+bottomOffset, [self width:ttItem], ttItem.frame.size.height);
    
    yyItem.frame = CGRectMake(0, [self bottom:circleView]+bottomOffset, [self width:yyItem], yyItem.frame.size.height);
    yyItem.center = CGPointMake(self.bgView.center.x, yyItem.center.y);
    
    balanceItem.frame = CGRectMake(self.bgView.frame.origin.x+self.bgView.frame.size.width-15, [self bottom:circleView]+bottomOffset, [self width:yyItem], yyItem.frame.size.height);
    yyItem.center = CGPointMake(self.bgView.center.x, yyItem.center.y);
    
}
- (CGFloat)bottom:(UIView*)view{
    return view.frame.origin.y+view.frame.size.height;
}
- (CGFloat)width:(UIView*)view{
    return view.frame.size.width;
}
- (UIView *)makeBottomItem:(NSString *)name text:(NSString *)text
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blueColor];
    
    UIImageView *ttImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [view addSubview:ttImgV];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor lightGrayColor];
    lab.text = text;
    [view addSubview:lab];
    
    ttImgV.frame = CGRectMake(0, ttImgV.frame.origin.y, ttImgV.frame.size.width, ttImgV.frame.size.height);
    
    lab.frame = CGRectMake(ttImgV.frame.origin.x+ttImgV.frame.size.width+5, ttImgV.frame.origin.y, ttImgV.frame.size.width, ttImgV.frame.size.height);
    lab.center   = CGPointMake(lab.center.x, ttImgV.center.y);

    view.frame = CGRectMake(lab.frame.origin.x+lab.frame.size.width,
                            0,
                            SCREENT_WIDTH,
                            lab.frame.origin.y+lab.frame.size.height);
    
    return view;
}

@end

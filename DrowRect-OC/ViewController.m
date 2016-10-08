//
//  ViewController.m
//  DrowRect-OC
//
//  Created by fans on 16/10/8.
//  Copyright © 2016年 Fans. All rights reserved.
//

#import "ViewController.h"
#import "PieView.h"

@interface ViewController ()
@property(nonatomic, strong)PieView *pie;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *colors = @[
                        [UIColor redColor],
                        [UIColor yellowColor],
                        [UIColor blueColor]
                        ];
    CGRect frame = CGRectMake(0, 0, 200, 200);
    _pie = [[PieView alloc] initWithFrame:frame dataItems:@[@4,@1,@5] colorItems:colors];
    [self.view addSubview:_pie];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_pie stroke];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

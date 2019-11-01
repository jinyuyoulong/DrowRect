//
//  PieView.h
//  DrowRect-OC
//
//  Created by fans on 16/10/8.
//  Copyright © 2016年 Fans. All rights reserved.
//  饼形图

#import <UIKit/UIKit.h>

/** 饼图 主页面
 DocA : 类描述，饼图 惊呆了看啦
 adjlfjalda 大冷风机埃里克的法律
 3 line 打蜡发了快递费
 @file    PieView.h
 @author    [fans](http:v5u.win)
 @version    1.0
 @date    2013-06-07
 
  # update （更新日志）
 
  [2013-06-07] <fans> v1.1
 
  + v1.1版发布.
 */
@interface PieView : UIView
/// 文本注释title
@property (nonatomic, strong) NSArray *titles; //!< 尾行注释 文本。appledoc不可用

/**
 只有饼图和比例

 @param frame      frame
 @param dataItems  数据集
 @param colorItems 色值集

 @return self
 */
- (id)initWithFrame:(CGRect)frame dataItems:(NSArray*)dataItems colorItems:(NSArray*)colorItems;
/// - 添加一个链接: [百度](http://www.baidu.com)
- (void)stroke;

/**
 有文字描述

 @param dataItems 数据集
 @param titles 说明title
 @param colorItems 色值集
 @return self
 */
- (id)initWithDataItems:(NSArray*)dataItems titles:(NSArray*)titles colorItems:(NSArray*)colorItems;
@end

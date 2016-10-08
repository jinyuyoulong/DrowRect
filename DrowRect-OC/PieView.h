//
//  PieView.h
//  DrowRect-OC
//
//  Created by fans on 16/10/8.
//  Copyright © 2016年 Fans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieView : UIView

/**
 初始化 数据和颜色值

 @param frame      <#frame description#>
 @param dataItems  <#dataItems description#>
 @param colorItems <#colorItems description#>

 @return <#return value description#>
 */
- (id)initWithFrame:(CGRect)frame dataItems:(NSArray*)dataItems colorItems:(NSArray*)colorItems;
- (void)stroke;

@end

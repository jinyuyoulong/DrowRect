//
//  UIColor+Hex.m
//  DrowRect-OC
//
//  Created by 范金龙 on 2019/11/1.
//  Copyright © 2019 Fans. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)
#pragma mark - public API
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    return [self colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    const char *cString = [hexString cStringUsingEncoding: NSASCIIStringEncoding];
    NSInteger hex;
    
    // if the string contains hash tag (#) then remove
    // hash tag and convert the C string to a base-16 int
    if (cString[0] == '#') {
        hex = strtol(cString + 1, NULL, 16);
    }else {
        hex = strtol(cString, NULL, 16);
    }
    
    return [self colorWithHex: hex alpha:alpha];
}

#pragma mark - private methods
+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0x00FF00) >> 8))  / 255.0
                            blue:((float)((hex & 0x0000FF) >> 0))  / 255.0
                           alpha:alpha];
}
@end

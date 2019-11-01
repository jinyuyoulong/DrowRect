//
//  NSString+Handler.m
//  DrowRect-OC
//
//  Created by 范金龙 on 2019/11/1.
//  Copyright © 2019 Fans. All rights reserved.
//

#import "NSString+Handler.h"

@implementation NSString (Handler)
- (NSString *)trimSemicolon{
    return [self stringByReplacingOccurrencesOfString:@"," withString:@""];
}
@end

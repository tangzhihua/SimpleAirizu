//
//  UIColor+Helper.h
//  ModelLib
//
//  Created by 唐志华 on 14-3-19.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import <UIKit/UIKit.h>

// 从 16进制的字符串转成UIColor对象
@interface UIColor (HexConvert)
+ (UIColor *)colorFromHexString:(NSString *)colorString;
+ (NSString *)stringFromColor:(UIColor *)color;

- (void)getRGBComponents:(CGFloat [3])components;
@end

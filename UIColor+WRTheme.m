//
//  UIColor+WRTheme.m
//  WRTopBarView
//
//  Created by HW1-MM02 on 2017/5/22.
//  Copyright © 2017年 HW1-MM02. All rights reserved.
//

#import "UIColor+WRTheme.h"

@implementation UIColor (WRTheme)
+ (UIColor *)colorWithHex:(UInt32)hex {
    return [UIColor colorWithHex:hex alpha:1.f];
}

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}
+(UIColor *)WR_TopBarBGColor
{
    return [UIColor colorWithHex:0x254659];
}
+(UIColor *)WR_NormTextColor
{
    return [UIColor colorWithHex:0xff1643];
}
+(UIColor *)WR_SelectedTextColor
{
    return [UIColor colorWithHex:0x0074E1];
}
+(UIColor *)WR_RandomColor
{
    CGFloat hue = (arc4random() %256/256.0);
    
    CGFloat saturation = (arc4random() %128/256.0) +0.5;
    
    CGFloat brightness = (arc4random() %128/256.0) +0.5;
    
    UIColor*color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}
@end

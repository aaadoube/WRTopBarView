//
//  UIColor+WRTheme.h
//  WRTopBarView
//
//  Created by HW1-MM02 on 2017/5/22.
//  Copyright © 2017年 HW1-MM02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WRTheme)

/**
 *  标题栏背景颜色
 */
+(UIColor *)WR_TopBarBGColor;

/**
 *  默认数据字体颜色
 */
+(UIColor *)WR_NormTextColor;
/**
 *  选中数据字体颜色
 */
+(UIColor *)WR_SelectedTextColor;
/**
 *  随机颜色
 */
+(UIColor *)WR_RandomColor;

@end

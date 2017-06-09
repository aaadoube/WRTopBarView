//
//  WRTopBarView.h
//  WRTopBarView
//
//  Created by HW1-MM02 on 2017/5/17.
//  Copyright © 2017年 HW1-MM02. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WRTopBarView;
@class WRSelectMenuView;
typedef NS_ENUM(NSUInteger, WRTopBarStyle) {
    WRTopBarStyleInScreen = 1,
    WRTopBarStyleOutScreen,
    WRTopBarStyleOther
};

@protocol WRTopBarViewDelegate <NSObject>

@required

/**
 点击按钮的响应事件

 @param topbarView 当前的topbarView
 @param index 点击按钮的索引，从0开始
 */
- (void)WRTopBarView:(WRTopBarView *)topbarView selectedIndex:(NSInteger)index;
@optional

/**
 选择以initWithItems: foldUpFromIndex: menuTitle: 方式初始化topBar时，创建下拉菜单

 @param selectBtn 点击该按钮出现下拉菜单
 @param btnArr 下拉菜单中的按钮
 @return 返回下拉菜单视图
 */
- (WRSelectMenuView *)createSelectViewWithSelectBtn:(UIButton *)selectBtn AndbtnArr:(NSMutableArray *)btnArr;
@end

@interface WRTopBarView : UIView

@property (nonatomic,weak) id<WRTopBarViewDelegate> delegate;
/**
 初始化方法
 
 @param titleItems 传入标题数组
 @param style       是否限制所有的按钮都在一屏内
 
 @return WRTopBarView
 */
- (instancetype)initWithItems:(NSArray <NSString *>*)titleItems distributionStyle: (WRTopBarStyle)style;
/**
 初始化方法
 
 @param titleItems 传入标题数组
 @param beginIndex 从第几个按钮开始折叠
 
 @return WRTopBarView
 */
- (instancetype)initWithItems:(NSArray <NSString *>*)titleItems foldUpFromIndex: (NSInteger)beginIndex menuTitle:(NSString *)menuTitle;
@end















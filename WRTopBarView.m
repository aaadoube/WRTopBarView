//
//  WRTopBarView.m
//  WRTopBarView
//
//  Created by HW1-MM02 on 2017/5/17.
//  Copyright © 2017年 HW1-MM02. All rights reserved.
//

#import "WRTopBarView.h"
#import "Masonry.h"
#import "WRSelectMenuView.h"
#import "UIColor+WRTheme.h"

#define TopBarHight 40 
#define IndicatorViewHeight 2
#define IndicatorViewWidth 28

@interface WRTopBarView()<UIScrollViewDelegate>



/**
 标题下方的指示器
 */
@property (nonatomic, strong) UIView *indicatorView;

/**
 持有数据源
 */
@property (nonatomic, copy) NSArray <NSString *>*titleItems;

/**
 scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 按钮排列样式
 */
@property (nonatomic, assign) WRTopBarStyle distributionStyle;

/**
 当前选中的index
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

/**
 持有按钮数组
 */
@property (nonatomic, strong) NSMutableArray *btnArray;
/**
 下拉选择按钮
 */
@property (nonatomic, strong) UIButton *selectBtn;
/**
 下拉选择视图
 */
@property (nonatomic, strong) WRSelectMenuView *selectView;
/**
 下拉选择的按钮组
 */
@property (nonatomic, strong) NSMutableArray *selectViewBtnArr;

@end

@implementation WRTopBarView
{
    NSInteger _beginIndex;
    NSString * _menuTitle;
}
-(instancetype)initWithItems:(NSArray<NSString *> *)titleItems distributionStyle:(WRTopBarStyle)style
{
    if (self=[super init]) {
        _titleItems = titleItems;
        _distributionStyle = style;
        _beginIndex=2048;
        [self setupHeadView];
    }
    return self;
}
-(instancetype)initWithItems:(NSArray<NSString *> *)titleItems foldUpFromIndex:(NSInteger)beginIndex menuTitle:(NSString *)menuTitle
{
    if (self=[super init]) {
        _titleItems = titleItems;
        
        if (titleItems.count<beginIndex+1) {
            _distributionStyle = WRTopBarStyleInScreen;
            [self setupHeadView];
        }else{
            _beginIndex=beginIndex;
            _distributionStyle = WRTopBarStyleOther;
            _menuTitle=menuTitle;
            [self setupHeadViewWithBeginIndex:beginIndex];
        }
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.distributionStyle == WRTopBarStyleInScreen) {
        self.scrollView.contentSize = self.scrollView.bounds.size;
    }
}

/**
 初始化顶部按钮在一屏内
 */
- (void)initTopBarInScreen {
    self.scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        //        scrollView.backgroundColor = [self bgColor];
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //按钮组
        __block UIButton *lastBtn;
        __block UIButton *firstBtn;
        self.btnArray = @[].mutableCopy;
        __weak typeof(self) weakSelf=self;
        [self.titleItems enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [weakSelf createBtnWithTitle:obj tag:idx+100];
            [scrollView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(scrollView);
                make.width.equalTo(scrollView).multipliedBy(1.f/self.titleItems.count);
                make.left.equalTo(lastBtn == nil ? scrollView.mas_left : lastBtn.mas_right);
                make.height.equalTo(@(TopBarHight - IndicatorViewHeight));
            }];
            if (!lastBtn) firstBtn = btn;
            lastBtn = btn;
        }];
        
        //指示器
        UIView *indicatorView = [UIView new];
        indicatorView.backgroundColor = [self lineSelectedColor];
        [scrollView addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
        
        
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@IndicatorViewHeight);
            make.width.equalTo(@(lastBtn.titleLabel.frame.size.width));
            make.top.equalTo(lastBtn.mas_bottom);
            make.centerX.equalTo(firstBtn.mas_centerX);
        }];
        
        scrollView.contentSize = self.frame.size;
        scrollView;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateBtnUI:nil newBtn:[self.scrollView.subviews firstObject]];
    });
}

/**
 初始化顶部按钮，无一屏限制
 */
- (void)initTopBarOutScreen {
    self.scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //按钮组
        __block UIButton *lastBtn;
        __block UIButton *firstBtn;
        __weak typeof(self) weakSelf=self;
        [self.titleItems enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [weakSelf createBtnWithTitle:obj tag:idx+100];
            [scrollView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(scrollView.mas_top);
                make.height.equalTo(@(TopBarHight - IndicatorViewHeight));
                make.width.equalTo(@TopBarHight);
                make.left.equalTo(scrollView).offset(TopBarHight * idx);
            }];
            if (!lastBtn) firstBtn = btn;
            lastBtn = btn;
            
        }];
        
        //指示器
        UIView *indicatorView = [UIView new];
        indicatorView.backgroundColor = [self lineSelectedColor];
        [scrollView addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
        
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor WR_SelectedTextColor]};
            CGSize textSize = [self rectOfNSString:lastBtn.titleLabel.text attribute:attribute].size;
            make.height.equalTo(@IndicatorViewHeight);
            make.width.equalTo(@(textSize.width));
            make.top.equalTo(lastBtn.mas_bottom);
            make.centerX.equalTo(firstBtn.mas_centerX);
        }];
        
        
        scrollView.contentSize = CGSizeMake(self.titleItems.count * IndicatorViewWidth, TopBarHight);
        scrollView;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateBtnUI:nil newBtn:[self.scrollView.subviews firstObject]];
    });
}

/**
 初始化顶部按钮
 */
- (void)setupHeadView {
    switch (self.distributionStyle) {
        case WRTopBarStyleInScreen :
            [self initTopBarInScreen];
            break;
        case WRTopBarStyleOutScreen:
            [self initTopBarOutScreen];
            break;
        default:
            break;
    }
}
/**
 初始化顶部按钮
 */
- (void)setupHeadViewWithBeginIndex:(NSInteger)index {
    self.scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //按钮组
        __block UIButton *lastBtn;
        __block UIButton *firstBtn;
        self.btnArray = @[].mutableCopy;
        __weak typeof(self) weakSelf=self;
        [self.titleItems enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (index==idx) {
                //下拉点击按钮
                [scrollView addSubview: weakSelf.selectBtn];
                [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(scrollView);
                    make.width.equalTo(scrollView).multipliedBy(1.f/(index+1));
                    make.left.equalTo(lastBtn == nil ? scrollView.mas_left : lastBtn.mas_right);
                    make.height.equalTo(@(TopBarHight - IndicatorViewHeight));
                }];
                if (!lastBtn) firstBtn = weakSelf.selectBtn;
                lastBtn=weakSelf.selectBtn;
                
                UIButton *btn = [weakSelf createBtnWithTitle:obj tag:idx+100];
                [weakSelf.selectViewBtnArr addObject:btn];
                
            }else if (idx>index){
                //折叠按钮以后的Btn
                UIButton *btn = [weakSelf createBtnWithTitle:obj tag:idx+100];
                [self.selectViewBtnArr addObject:btn];
                
            }else{
                UIButton *btn = [weakSelf createBtnWithTitle:obj tag:idx+100];
                [scrollView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(scrollView);
                    make.width.equalTo(scrollView).multipliedBy(1.f/(index+1));
                    make.left.equalTo(lastBtn == nil ? scrollView.mas_left : lastBtn.mas_right);
                    make.height.equalTo(@(TopBarHight - IndicatorViewHeight));
                }];
                if (!lastBtn) firstBtn = btn;
                lastBtn = btn;
            }
            
            
        }];
        
        
        //指示器
        UIView *indicatorView = [UIView new];
        indicatorView.backgroundColor = [self lineSelectedColor];
        [scrollView addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
        
        
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@IndicatorViewHeight);
            make.width.equalTo(@(lastBtn.titleLabel.frame.size.width));
            make.top.equalTo(lastBtn.mas_bottom);
            make.centerX.equalTo(firstBtn.mas_centerX);
        }];
        
        scrollView.contentSize = self.frame.size;
        scrollView;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateBtnUI:nil newBtn:[self.scrollView.subviews firstObject]];
    });
}
/**
 按钮点击事件
 
 @param btn 被点击的按钮
 */
- (void)didClickBtnAction:(UIButton *)btn {
    self.userInteractionEnabled= NO;
    
    if (btn.tag==2048) {
        //点击了菜单按钮
        if (self.selectView==nil) {
            if ([self.delegate respondsToSelector:@selector(createSelectViewWithSelectBtn:AndbtnArr:)]) {
                self.selectView=[self.delegate createSelectViewWithSelectBtn:btn AndbtnArr:_selectViewBtnArr];
            }
        }else{
            self.selectView.hidden=NO;
        }
        
    }
    else{
        //点击了其他按钮
        if (self.selectView !=nil){
            self.selectView.hidden=YES;
        }
        
        [self updateBtnUI:self.btnArray[self.selectedIndex] newBtn:btn];

        
        
        if ([self.delegate respondsToSelector:@selector(WRTopBarView:selectedIndex:)]) {
            [self.delegate WRTopBarView:self selectedIndex:btn.tag-100];
        }
        
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled= YES;
    });
    
    
}
//滚动scrollview
-(void)setScrollViewAfterClick:(UIButton *)btn
{
    //滚动scrollview
    CGFloat willOffsetX = ((btn.frame.origin.x + btn.frame.size.width/2.f) - self.bounds.size.width/2.f);
    [UIView animateWithDuration:.5f animations:^{
        if (willOffsetX < 0) {
            _scrollView.contentOffset = CGPointZero;
        } else if(willOffsetX + _scrollView.bounds.size.width > _scrollView.contentSize.width) {
            _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width - _scrollView.bounds.size.width, 0);
        } else {
            _scrollView.contentOffset = CGPointMake(willOffsetX, 0);
        }
    }];
}

/**
 选中按钮
 
 @param index 按钮index
 */
- (void)selectIndex:(NSInteger)index {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self didClickBtnAction:[self.scrollView viewWithTag:index + 100]];
    });
}

/**
 更新UI
 
 @param oldBtn 原按钮
 @param newBtn 新按钮
 */
- (void)updateBtnUI: (UIButton *)oldBtn newBtn:(UIButton *)newBtn{
    oldBtn.selected = NO;
    [newBtn setSelected:YES];
    
    
    if (newBtn.tag-100>=_beginIndex) {
        //点击的是其他菜单中的按钮
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.selectBtn.mas_centerX);
            make.height.equalTo(@IndicatorViewHeight);
            make.width.equalTo(@(self.selectBtn.titleLabel.frame.size.width));
            make.top.equalTo(self.selectBtn.mas_bottom);
        }];
        NSString * titleStr=_titleItems[newBtn.tag-100];
        
        self.selectBtn.selected=YES;
        [self.selectBtn setTitle:titleStr forState:UIControlStateNormal];
    }
    else{
        //点击的是topbar上的按钮（除其他按钮外）
        if (self.distributionStyle==WRTopBarStyleOther) {
            self.selectBtn.selected=NO;
            [self.selectBtn setTitle:_menuTitle forState:UIControlStateNormal];
        }
        
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(newBtn.mas_centerX);
            make.height.equalTo(@IndicatorViewHeight);
            make.width.equalTo(@(newBtn.titleLabel.frame.size.width));
            make.top.equalTo(newBtn.mas_bottom);
        }];
        
    }
    self.selectedIndex = newBtn.tag-100;
    __weak typeof(self) weakSelf=self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf layoutIfNeeded];
    }];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y != 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

/**
 创建按钮
 
 @param title 标题
 @param tag tag
 
 @return 按钮
 */
- (UIButton *)createBtnWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[self textNormalColor] forState:UIControlStateNormal];
    [btn setTitleColor:[self textSelectedColor] forState:UIControlStateSelected];
    btn.tag = tag;
    [btn addTarget:self action:@selector(didClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnArray addObject:btn];
    return btn;
}

- (UIColor *)textNormalColor {
    return [UIColor WR_NormTextColor];
}

- (UIColor *)textSelectedColor {
    return [UIColor WR_SelectedTextColor];
}

- (UIColor *)lineSelectedColor {
    return [UIColor WR_SelectedTextColor];
}

- (UIColor *)bgColor {
    return [UIColor WR_TopBarBGColor];
}
-(UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn=[UIButton new];
        [_selectBtn setTitle:_menuTitle forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectBtn setTitleColor:[self textNormalColor] forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[self textSelectedColor] forState:UIControlStateSelected];
        
        _selectBtn.tag = 2048;
        [_selectBtn addTarget:self action:@selector(didClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * label=[[UILabel alloc] init];
        label.textColor=[self textSelectedColor];
        label.font=[UIFont systemFontOfSize:6];
        label.text=@"◢";
        [_selectBtn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_selectBtn);
            make.right.equalTo(_selectBtn);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(12);
        }];
    }
    return _selectBtn;
}
-(NSMutableArray *)selectViewBtnArr
{
    if (!_selectViewBtnArr) {
        _selectViewBtnArr=[NSMutableArray array];
    }
    return _selectViewBtnArr;
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}
@end

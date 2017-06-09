//
//  SecondViewCtrl.m
//  WRTopBarView
//
//  Created by HW1-MM02 on 2017/5/22.
//  Copyright © 2017年 HW1-MM02. All rights reserved.
//

#import "SecondViewCtrl.h"
#import "WRTopBarView.h"
#import "WRSelectMenuView.h"
#import "UIColor+WRTheme.h"
#import "Masonry.h"
@interface SecondViewCtrl ()<WRTopBarViewDelegate>
@property (nonatomic,strong)WRTopBarView *topBarView;
@property (nonatomic,strong)NSMutableArray <__kindof UIView *> * stockViewArray;
@end

@implementation SecondViewCtrl
{
    NSArray * _titleArr;
    NSInteger currentIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleArr=@[@"标题1",@"标题2",@"标题3",@"标题4",@"标题5",@"标题6",@"标题7",@"标题8"];
    self.stockViewArray=[NSMutableArray array];
    [self initUI_TopBarView];
    [self initUI_ContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initUI_TopBarView {
//    _topBarView = [[WRTopBarView alloc]initWithItems:_titleArr foldUpFromIndex:5 menuTitle:@"其他"];
        _topBarView = [[WRTopBarView alloc] initWithItems:_titleArr distributionStyle:WRTopBarStyleInScreen];
    
    [self.view addSubview:_topBarView];
    [_topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.height.equalTo(@40);
    }];
    _topBarView.delegate = self;
}
- (void)initUI_ContentView {
    [_titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 50, 234, 500)];
        //第一个视图不隐藏
        if (idx == 0) {
            view.hidden = NO;
        } else {
            view.hidden = YES;
        }
        
        view.backgroundColor = [UIColor WR_RandomColor];
        [self.view addSubview:view];
        [self.stockViewArray addObject:view];
    }];
}
/**
 topBarView代理
 
 @param topbarView topBarView
 @param index      选中index
 */
-(void)WRTopBarView:(WRTopBarView *)topbarView selectedIndex:(NSInteger)index
{
    
    self.stockViewArray[currentIndex].hidden = YES;
    self.stockViewArray[index].hidden = NO;
    currentIndex = index;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

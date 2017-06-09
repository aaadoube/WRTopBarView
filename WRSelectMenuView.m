//
//  WRSelectMenuView.m
//  WRTopBarView
//
//  Created by HW1-MM02 on 2017/5/22.
//  Copyright © 2017年 HW1-MM02. All rights reserved.
//

#import "WRSelectMenuView.h"
#import "Masonry.h"
#import "UIColor+WRTheme.h"
@interface WRSelectMenuView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WRSelectMenuView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self=[super initWithFrame:frame style:style]) {
        //
        self.backgroundColor=[UIColor WR_TopBarBGColor];
        [self.btnArr removeAllObjects];
        self.delegate=self;
        self.dataSource=self;
        
    }
    return self;
}
-(NSInteger)numberOfSections
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%ld",self.btnArr.count);
    return self.btnArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellStr=@"cellSelectBtn";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.contentView.backgroundColor=[UIColor WR_TopBarBGColor];
    }
    //禁止单元格高亮显示
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //超出父视图不显示，如果不将其值设为YES（默认为NO），那么实现在表视图上的数据会出现重叠的bug
    cell.layer.masksToBounds=YES;
    UIButton * btn=self.btnArr[indexPath.row];
    [cell.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(cell);
    }];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38.0;
}
-(NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr=[NSMutableArray array];
    }
    return _btnArr;
}

@end

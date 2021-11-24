//
//  HeaderView.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/8.
//

#import "HeaderView.h"
#import <Masonry/Masonry.h>
#import "PNChart.h"
@interface HeaderView (){
    UILabel *thisMonthExpengseLable;
    UILabel *thisMonthIncomeLable;
    UILabel *budgetSurplusLable;
    UILabel *propertyLabel;
    PNCircleChart  *circleChart;
}

@end

@implementation HeaderView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, self.bounds.size.width-30, self.bounds.size.height)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        propertyLabel = [[UILabel alloc] init];
        [backView addSubview:propertyLabel];
        [propertyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(backView).mas_offset(5);
            make.left.mas_equalTo(backView).mas_offset(5);
            make.width.mas_equalTo(backView.frame.size.width);
            make.height.mas_offset(30);
        }];
        UILabel *expengseL = [[UILabel alloc] init];
        expengseL.text = @"本月支出";
        expengseL.font = [UIFont systemFontOfSize:12];
        expengseL.textColor = [UIColor grayColor];
        [backView addSubview:expengseL];
        [expengseL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(propertyLabel.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(backView).mas_offset(5);
            make.width.mas_equalTo(100);
            make.height.mas_offset(20);
        }];
        thisMonthExpengseLable = [[UILabel alloc] init];
        thisMonthExpengseLable.font = [UIFont boldSystemFontOfSize:30];
        [backView addSubview:thisMonthExpengseLable];
        [thisMonthExpengseLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(expengseL).mas_offset(5);
            make.left.mas_equalTo(backView).mas_offset(5);
            make.width.mas_equalTo((backView.frame.size.width-21)/2);
            make.height.mas_equalTo(100);
        }];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = grayBaseColor;
        [backView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(thisMonthExpengseLable);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(100);
        }];
       
        thisMonthIncomeLable = [[UILabel alloc] init];
        thisMonthIncomeLable.font = [UIFont boldSystemFontOfSize:30];
        [backView addSubview:thisMonthIncomeLable];

        [thisMonthIncomeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(thisMonthExpengseLable);
            make.left.mas_equalTo(lineView.mas_right).mas_offset(10);
            make.width.mas_equalTo((backView.frame.size.width-21)/2);
            make.height.mas_offset(100);
        }];
        UILabel *incomeL = [[UILabel alloc] init];
        incomeL.text = @"本月收入";
        incomeL.font = [UIFont systemFontOfSize:12];
        incomeL.textColor = [UIColor grayColor];

        [backView addSubview:incomeL];
        [incomeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lineView.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(expengseL);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        budgetSurplusLable = [[UILabel alloc] init];
        budgetSurplusLable.font = [UIFont systemFontOfSize:12];

        budgetSurplusLable.textColor  = [UIColor grayColor];
        [backView addSubview:circleChart];
        [backView addSubview:budgetSurplusLable];

        [budgetSurplusLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(thisMonthIncomeLable.mas_bottom).mas_offset(-10);
            make.right.mas_equalTo(backView.mas_right).mas_offset(-10);
            make.height.mas_offset(50);
        }];
    }
    return self;
}
- (void) setUserData:(UserDataModel *)userData {
    
    float budgetSurplus = userData.budgetSurplus - [[userData.allRecordArray lastObject].thisYearRecord lastObject].thisMonthExpense;
    
    
    
    thisMonthExpengseLable.text = [NSString stringWithFormat:@"%.2f",[[userData.allRecordArray lastObject].thisYearRecord lastObject].thisMonthExpense];
    thisMonthIncomeLable.text = [NSString stringWithFormat:@"%.2f",[[userData.allRecordArray lastObject].thisYearRecord lastObject].thisMonthIncome];
    [circleChart updateChartByCurrent:[NSNumber numberWithFloat: budgetSurplus] byTotal:[NSNumber numberWithFloat: userData.budgetSurplus]];

    NSString *budgetStr = [NSString stringWithFormat:@"预算结余： %.2f",budgetSurplus];

    // 初始化属性字符串
    NSMutableAttributedString *attrbudgetStr = [[NSMutableAttributedString alloc] initWithString: budgetStr];
    [attrbudgetStr addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} range:NSMakeRange(5, budgetStr.length-5)];

    budgetSurplusLable.attributedText = attrbudgetStr;
    NSString *propertyStr = [NSString stringWithFormat:@"资产 ： %.2f",userData.allProperty+userData.allIncome-userData.allExpense];
    // 初始化属性字符串
    NSMutableAttributedString *attrpropertyStr = [[NSMutableAttributedString alloc] initWithString: propertyStr];
    [attrpropertyStr addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} range:NSMakeRange(3, attrpropertyStr.length-3)];
    propertyLabel.attributedText = attrpropertyStr;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  SortManagementHeaderView.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/13.
//

#import "SortManagementHeaderView.h"
@interface SortManagementHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *expenseButton;
@property (weak, nonatomic) IBOutlet UIButton *incomeButton;

@end

@implementation SortManagementHeaderView
- (void)setNeedsLayout{
    
}
- (void)layoutIfNeeded{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self) {
        [self.expenseButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.incomeButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.expenseButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.incomeButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if (self.recordType) {
            self.incomeButton.selected = YES;
            self.expenseButton.selected = NO;
            [self.expenseButton setBackgroundColor:[UIColor systemGray5Color]];
            [self.incomeButton setBackgroundColor:incomeColor];
        }else{
            self.incomeButton.selected = NO;
            self.expenseButton.selected = YES;
            [self.incomeButton setBackgroundColor:[UIColor systemGray5Color]];
            [self.expenseButton setBackgroundColor:ExpenseColor];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (IBAction)tapExpenseButton:(UIButton *)sender {
    self.recordType = NO;
    self.expenseButton.selected = YES;
    self.incomeButton.selected = NO;
    [self.incomeButton setBackgroundColor:[UIColor systemGray5Color]];
    [self.expenseButton setBackgroundColor:ExpenseColor];
    self.tapButton(self.recordType);
}
- (IBAction)tapIncomeButton:(UIButton *)sender {
    self.recordType = YES;
    self.expenseButton.selected = NO;
    self.incomeButton.selected = YES;
    [self.expenseButton setBackgroundColor:[UIColor systemGray5Color]];
    [self.incomeButton setBackgroundColor:incomeColor];
    self.tapButton(self.recordType);
}

@end

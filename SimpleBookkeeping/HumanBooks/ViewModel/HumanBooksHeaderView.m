//
//  HumanBooksHeaderView.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/31.
//

#import "HumanBooksHeaderView.h"

@interface HumanBooksHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *giveGiftsLable;
@property (weak, nonatomic) IBOutlet UILabel *receivingGiftsLable;
@property (weak, nonatomic) IBOutlet UILabel *giveGiftsNumberLable;
@property (weak, nonatomic) IBOutlet UILabel *receivingGiftsNumberLable;

@end

@implementation HumanBooksHeaderView
-(void) setHeaderViewData:(HumanBooksModel *)humanBooks{
    self.giveGiftsLable.text = [NSString stringWithFormat:@"%.2f",[humanBooks.giveGiftsTotal floatValue]];
    self.receivingGiftsLable.text = [NSString stringWithFormat:@"%.2f",[humanBooks.receivingGiftsTotal floatValue]];
    self.giveGiftsNumberLable.text = [NSString stringWithFormat:@"送(%d笔)",[humanBooks.giveGiftsNumber intValue]];
    self.receivingGiftsNumberLable.text = [NSString stringWithFormat:@"收(%d笔)",[humanBooks.receivingGiftsNumber intValue]];

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

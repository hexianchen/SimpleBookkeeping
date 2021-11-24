//
//  HumanBooksCell.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/31.
//

#import "HumanBooksCell.h"
#import "HumanBooksModel.h"
@interface HumanBooksCell()
@property (weak, nonatomic) IBOutlet UILabel *differenceLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *giveGifts;
@property (weak, nonatomic) IBOutlet UILabel *receivingGifts;
@property (weak, nonatomic) IBOutlet UILabel *giveGiftsTyep;
@property (weak, nonatomic) IBOutlet UILabel *receivingGiftsType;
@end
@implementation HumanBooksCell

-(void) setCellData:(ShowHumanBooksModel *)showModel{
    self.nameLable.text = [NSString stringWithFormat:@"  %@",showModel.name];
    float difference = 0;
    NSMutableString *giveGiftsString = [NSMutableString new];
    NSMutableString *receivingGiftsString = [NSMutableString new];
    NSMutableString *giveGiftsTypeString = [NSMutableString new];
    NSMutableString *receivingGiftsTypeString = [NSMutableString new];
    for (RecordHumanBooksModel  *temp in showModel.giveGiftsArray) {
        [ giveGiftsString appendFormat:@"¥%.2f\n",[temp.money floatValue]];
        [ giveGiftsTypeString appendFormat:@"%@\n",temp.matter];
        difference += [temp.money floatValue];
    }
    for (RecordHumanBooksModel  *temp in showModel.receivingGiftsArray) {
        [ receivingGiftsString appendFormat:@"¥%.2f\n",[temp.money floatValue]];
        [ receivingGiftsTypeString appendFormat:@"%@\n",temp.matter];
        difference -= [temp.money floatValue];
    }
    self.giveGifts.text = giveGiftsString;
    self.giveGifts.numberOfLines = 0;
    self.receivingGifts.text = receivingGiftsString;
    self.receivingGifts.numberOfLines = 0;
    self.giveGiftsTyep.text = giveGiftsTypeString;
    self.receivingGiftsType.text = receivingGiftsTypeString;
    self.differenceLable.text = [NSString stringWithFormat:@"差额:%.f",difference];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

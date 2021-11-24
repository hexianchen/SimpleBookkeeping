//
//  RecordTableViewCell.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/9.
//

#import "RecordTableViewCell.h"
@interface RecordTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end
@implementation RecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void) loadThisView:(RecordModel *)data  indexPath:(NSInteger)indexPath{
    if (indexPath == 1) {
        [self.typeImg setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%@Select",data.iconImg]]];
        self.typeLable.text = [NSString stringWithFormat:@"%@",data.typeName ];
        self.moneyLable.text = [NSString stringWithFormat:@"¥%.2f",data.money];
        self.timeLable.hidden = NO;

        if (data.remark !=nil) {
            self.timeLable.text = [NSString stringWithFormat:@"%@ | 备注：%@",data.timeString, data.remark];

        }else{
            self.timeLable.text = data.timeString;

        }
    }else{
        self.timeLable.hidden = YES;
        [self.typeImg setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%@Select",data.type]]];
        self.typeLable.text = [NSString stringWithFormat:@"%@",data.typeName ];
        self.moneyLable.text = [NSString stringWithFormat:@"¥%.2f",data.money];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

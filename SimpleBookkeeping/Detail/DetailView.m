//
//  DetailView.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/21.
//

#import "DetailView.h"
#import <Masonry/Masonry.h>
@interface DetailView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UIView *backView;
    UIView *addView;
    UICollectionView *collectionView;
    NSInteger _choseYear;
    NSInteger _choseMonth;
}
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UILabel *expenseLable;
@property (weak, nonatomic) IBOutlet UILabel *incomeLable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *choseType;

@end
@implementation DetailView

- (void) setExpense:(NSString *)expenseString income:(NSString *)incomeString choseDateYear:(NSInteger)choseYear choseDatemonth:(NSInteger)choseMonth{
    _choseYear = choseYear;
    _choseMonth = choseMonth;
    [self.dateButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",_choseYear ,_choseMonth] forState:UIControlStateNormal];
    self.expenseLable.text = expenseString;
    self.incomeLable.text = incomeString;
}
- (IBAction)tapDateButton:(UIButton *)sender {
    [self creatAdddView];
//    self.tapDateBlock();
}
- (IBAction)tapChoseType:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.tapChoseTypeBlock(NO);
    }else{
        self.tapChoseTypeBlock(YES);

    }
}



- (void)creatAdddView{
    [self nsstringConversionNSDate:@"2021-10"];
    UIViewController *vc = [Tool getCurrentWindowVC];
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha =  0.3;
    
    [vc.view addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cleasView)];
    [backView  addGestureRecognizer:tap];
    
    
    addView = [[UIView alloc] init];
    addView.backgroundColor = [UIColor whiteColor];

    [vc.view addSubview:addView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(addView.mas_top);
    }];
    
    [addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
        make.top.mas_equalTo(backView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(vc.view.mas_bottom);
    }];
    //创建布局对象
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    //设置滚动方向为垂直滚动，说明方块是从左上到右下的布局排列方式
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//     //设置顶部视图和底部视图的大小，当滚动方向为垂直时，设置宽度无效，当滚动方向为水平时，设置高度无效
     layout.headerReferenceSize = CGSizeMake(100, 40);
//     layout.footerReferenceSize = CGSizeMake(100, 40);
    //创建容器视图
    CGRect frame =CGRectMake(0, 0, k_Screen_Width, 300);
    collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    //设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor systemGray6Color];;//设置背景，默认为黑色
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"detailCollectionViewCellID"];
    //一定要注册headview
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"leaveDetailsHeadID"];

//     registerNib:[UINib nibWithNibName:NSStringFromClass([TypeCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TypeCollectionViewCellID"];
    [addView addSubview:collectionView];
}

- (void) cleasView{
    [backView removeFromSuperview];
    [addView removeFromSuperview];
}
#pragma mark - UICollectionViewDelegateFlowLayout

/* 设置各个方块的大小尺寸 */
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
 

    CGFloat width = (collectionView.frame.size.width-50)/4;

    CGFloat height = 40;

    return CGSizeMake(width, height);

}

/* 设置每一组的上下左右间距 */

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout

insetForSectionAtIndex:(NSInteger)section

{

    return UIEdgeInsetsMake(10, 10, 10, 10);

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.useData.allRecordArray.count;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.useData.allRecordArray[section].thisYearRecord count];
}
//cell的header与footer的显示内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *reusableHeaderView = nil;

        if (reusableHeaderView==nil) {

            reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"leaveDetailsHeadID" forIndexPath:indexPath];
            reusableHeaderView.backgroundColor = [UIColor clearColor];

            //这部分一定要这样写 ，否则会重影，不然就自定义headview
            UILabel *label = (UILabel *)[reusableHeaderView viewWithTag:100];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, 0, self.frame.size.width, 40)];
                label.tag = 100;
                label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
                [reusableHeaderView addSubview:label];
            }
            label.text = [NSString stringWithFormat:@"%ld年", self.useData.allRecordArray[indexPath.section].recordYearDate];

        }
        return reusableHeaderView;
    }
    return nil;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detailCollectionViewCellID" forIndexPath:indexPath];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 30)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    ThisMonthDataModel *monthtemp = self.useData.allRecordArray[indexPath.section].thisYearRecord[indexPath.row];
    [btn setTitle:[NSString stringWithFormat:@"%ld月", monthtemp.recordMonthDate] forState:UIControlStateNormal];

    if ( self.useData.allRecordArray[indexPath.section].recordYearDate == _choseYear && monthtemp.recordMonthDate == _choseMonth) {
        [btn setBackgroundColor:ExpenseColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];


    }
    btn.userInteractionEnabled = NO;
    [cell.contentView addSubview:btn];
    
    return cell;
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ThisMonthDataModel *monthtemp = self.useData.allRecordArray[indexPath.section].thisYearRecord[indexPath.row];
    self.tapDateBlock(self.useData.allRecordArray[indexPath.section].recordYearDate, monthtemp.recordMonthDate);
    [self cleasView];
    
}
-(NSDate *)nsstringConversionNSDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  ViewController.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/8.
//

#import "HomeViewController.h"
#import "HeaderView.h"
#import <Masonry/Masonry.h>
#import "RecordTableViewCell.h"
#import "RecordMoneyViewController.h"
#import "UPButton.h"
#import "UserDataModel.h"
#import "MineViewController.h"
#import "HumanBooksViewController.h"
#import "RecoredEditVC.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UPButton *tableBackView;

@property (nonatomic, strong) UserDataModel  *userdataModel;
/**tableView的头视图*/
@property (nonatomic, strong)    HeaderView *headerView;


@end

@implementation HomeViewController
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headerView setUserData:self.userdataModel];
    [self.tableView reloadData];
    self.navigationItem.title = @"账房记";
    if (self.userdataModel.allRecordArray.count == 0) {
        UIView *back = [[UIView alloc] initWithFrame:self.view.bounds];
        UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(back.frame.size.width/2-100, back.frame.size.height/2-65, 200, 130)];
        [backImageView setImage:[UIImage imageNamed:@"noData"]];
        [back addSubview:backImageView];
        self.tableView.backgroundView = back;
    }else{
        self.tableView.backgroundView = nil;

    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleInsetGrouped];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"Identifier"];
    self.headerView = [[ HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
    [self.headerView setUserData:self.userdataModel];
    self.tableView.tableHeaderView = self.headerView;
//    [self.view addSubview:self.tableView];
//    [self addButton];

}

//获取本地的数据
- (void) getData{
    //读取文件
    NSData *readData = [Tool readLocalDataPathString:userRecordPathName];
    self.userdataModel =  [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[RecordModel class],[ThisDayDataModel class],[ThisMonthDataModel class],[ThisYearDataModel class],[UserDataModel class],[NSArray class],[NSDate class] ,nil] fromData:readData error:nil];
    if (self.userdataModel == nil) {
        self.userdataModel = [[UserDataModel alloc] init];
        
    }
    
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ThisDayDataModel *dayTemp = [[self.userdataModel.allRecordArray lastObject].thisYearRecord lastObject].thisMonthAllRecord[section];
    return  dayTemp.thisDayAllRecord.count;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = 0;
    for (ThisDayDataModel *temp in [[self.userdataModel.allRecordArray lastObject].thisYearRecord lastObject].thisMonthAllRecord) {
        if (temp.thisDayAllRecord.count>0) {
            count++;
        }
    }
    return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    
    ThisDayDataModel *dayTemp = [[self.userdataModel.allRecordArray lastObject].thisYearRecord lastObject].thisMonthAllRecord[indexPath.section];
    RecordModel *temp = dayTemp.thisDayAllRecord[indexPath.row];
    [cell loadThisView:temp indexPath:1];
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  70;
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ThisDayDataModel *dayTemp = [[self.userdataModel.allRecordArray lastObject].thisYearRecord lastObject].thisMonthAllRecord[section];
    return  [NSString stringWithFormat: @"%ld日 支出 ¥%.2f 收入 ¥%.2f",dayTemp.recordDayDate, dayTemp.thisDayExpense,dayTemp.thisDayIncome];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThisDayDataModel *dayTemp = [[self.userdataModel.allRecordArray lastObject].thisYearRecord lastObject].thisMonthAllRecord[indexPath.section];
    RecordModel *temp = dayTemp.thisDayAllRecord[indexPath.row];
    RecoredEditVC *vc = [[RecoredEditVC alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"详情" style:UIBarButtonItemStylePlain target:nil action:nil];
       [self.navigationItem setBackBarButtonItem:backItem];
    __weak typeof(self) weakSelf = self;
    vc.backRecordBlock = ^(RecordModel * _Nonnull record, NSInteger choseTpye) {
        if (choseTpye == 2) {
            [weakSelf updateUserData:record];
        }else{
            [weakSelf deleteUserData:record];

        }
        [weakSelf.headerView setUserData:weakSelf.userdataModel];
        [weakSelf.tableView reloadData];
    };
    vc.choseRecord = temp;
    vc.recordType = temp.recordType;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)addRecordButn:(UIButton *)sender {
    RecordMoneyViewController *recordVC = [[RecordMoneyViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
       [self.navigationItem setBackBarButtonItem:backItem];
    __weak typeof(self) weakSelf = self;
    recordVC.recordEditVC = [[RecoredEditVC alloc] init];

    recordVC.recordEditVC.backRecordBlock = ^(RecordModel * _Nonnull record, NSInteger choseTpye) {
        [weakSelf saveUserData:record];
        [weakSelf.headerView setUserData:weakSelf.userdataModel];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:recordVC animated:YES];
}
- (IBAction)humanBookBtn:(UIButton *)sender {
    HumanBooksViewController *humanBooks = [[HumanBooksViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"人情账本" style:UIBarButtonItemStylePlain target:nil action:nil];
       [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:humanBooks animated:YES];
}
- (IBAction)mineBtn:(UIButton *)sender {
    MineViewController *mineVC = [[MineViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:nil action:nil];
       [self.navigationItem setBackBarButtonItem:backItem];
    mineVC.userdataModel = self.userdataModel;
    [self.navigationController pushViewController:mineVC animated:YES];
}
#pragma mark -添加一条记录后，保存到本地
- (void) saveUserData:(RecordModel *)record{
    NSInteger yearsN = [Tool getDate:record.time dateType:@"YYYY"];
    NSInteger monthN = [Tool getDate:record.time dateType:@"MM"];
    NSInteger dayN = [Tool getDate:record.time dateType:@"dd"];

    BOOL isYear = NO;
    for (ThisYearDataModel *year in self.userdataModel.allRecordArray) {
        if (year.recordYearDate  == yearsN) {
            isYear = YES;
            BOOL isMonth = NO;
            for (ThisMonthDataModel *month in year.thisYearRecord) {
                if (month.recordMonthDate == monthN ) {
                    isMonth = YES;
                    BOOL isDay = NO;
                    for (ThisDayDataModel *day in month.thisMonthAllRecord) {
                        if (day.recordDayDate == dayN) {
                            day.recordDayDate = dayN;
                            record.ID = [[NSString stringWithFormat:@"%ld%ld%ld00%ld",yearsN,monthN,dayN,day.thisDayAllRecord.count+1] doubleValue];

                            [day.thisDayAllRecord addObject:record];
                            isDay = YES;
                            break;
                        }
                    }
                    if (!isDay) {
                        ThisDayDataModel *dayTemp = [[ThisDayDataModel alloc] init];
                        record.ID = [[NSString stringWithFormat:@"%ld%ld%ld001",yearsN,monthN,dayN] doubleValue];
                        [dayTemp.thisDayAllRecord addObject:record];
                        [month.thisMonthAllRecord addObject:dayTemp];
                    }
                }
            }
            if (!isMonth) {
                ThisMonthDataModel *monthTemp = [[ThisMonthDataModel alloc] init];
                ThisDayDataModel *dayTemp = [[ThisDayDataModel alloc] init];
                record.ID = [[NSString stringWithFormat:@"%ld%ld%ld001",yearsN,monthN,dayN] doubleValue];
                [dayTemp.thisDayAllRecord addObject:record];
                [monthTemp.thisMonthAllRecord addObject:dayTemp];
                [year.thisYearRecord addObject:monthTemp];
            }
        }
    }
    if (!isYear) {
        ThisYearDataModel *yearTemp = [[ThisYearDataModel alloc] init];
        ThisMonthDataModel *monthTemp = [[ThisMonthDataModel alloc] init];
        ThisDayDataModel *dayTemp = [[ThisDayDataModel alloc] init];
        record.ID = [[NSString stringWithFormat:@"%ld%ld%ld001",yearsN,monthN,dayN] doubleValue];
        [dayTemp.thisDayAllRecord addObject:record];
        [monthTemp.thisMonthAllRecord addObject:dayTemp];
        [yearTemp.thisYearRecord addObject:monthTemp];
        [self.userdataModel.allRecordArray addObject:yearTemp];
    }
    //保存数据到本地
    [Tool saveLocalData:self.userdataModel pathNameString:userRecordPathName];
   
}
#pragma mark -删除一条记录后，保存到本地
- (void) deleteUserData:(RecordModel *)record{
    NSInteger yearsN = [Tool getDate:record.time dateType:@"YYYY"];
    NSInteger monthN = [Tool getDate:record.time dateType:@"MM"];
    NSInteger dayN = [Tool getDate:record.time dateType:@"dd"];
    for (ThisYearDataModel *year in self.userdataModel.allRecordArray) {
        if (year.recordYearDate  == yearsN) {
            for (ThisMonthDataModel *month in year.thisYearRecord) {
                if (month.recordMonthDate == monthN ) {
                    for (ThisDayDataModel *day in month.thisMonthAllRecord) {
                        if (day.recordDayDate == dayN) {
                            for (RecordModel *recordTemp in day.thisDayAllRecord) {
                                if (recordTemp.ID == record.ID) {
                                    [day.thisDayAllRecord removeObject:recordTemp];
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //保存数据到本地
    [Tool saveLocalData:self.userdataModel pathNameString:userRecordPathName];
}
#pragma mark -修改一条记录后，保存到本地
- (void) updateUserData:(RecordModel *)record{
    NSInteger yearsN = [Tool getDate:record.time dateType:@"YYYY"];
    NSInteger monthN = [Tool getDate:record.time dateType:@"MM"];
    NSInteger dayN = [Tool getDate:record.time dateType:@"dd"];
    for (ThisYearDataModel *year in self.userdataModel.allRecordArray) {
        if (year.recordYearDate  == yearsN) {
            for (ThisMonthDataModel *month in year.thisYearRecord) {
                if (month.recordMonthDate == monthN ) {
                    for (ThisDayDataModel *day in month.thisMonthAllRecord) {
                        if (day.recordDayDate == dayN) {
                            int index = 0;
                            for (RecordModel *recordTemp in day.thisDayAllRecord) {
                                if (recordTemp.ID == record.ID) {
                                    [day.thisDayAllRecord replaceObjectAtIndex:index withObject:record];
                                    break;
                                }
                                index++;
                            }
                        }
                    }
                }
            }
        }
    }
    //保存数据到本地
    [Tool saveLocalData:self.userdataModel pathNameString:userRecordPathName];
}
@end

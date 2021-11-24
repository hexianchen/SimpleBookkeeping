//
//  DetailViewController.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/19.
//

#import "DetailViewController.h"
#import "PNChart.h"
#import "DetailView.h"
#import "RecordTableViewCell.h"
@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource,PNChartDelegate>
{
    NSMutableArray *monthArray;
 
    NSMutableArray *dayArray;
    NSMutableArray  *monthTypeArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**属性名称*/
@property (nonatomic, strong) DetailView *headView;
/**属性名称*/
@property (nonatomic, assign)     BOOL choseType;
/**属性名称*/
@property (nonatomic, assign)     NSInteger choseYear;
/**属性名称*/
@property (nonatomic, assign)     NSInteger choseMonth;
/**属性名称*/
@property (nonatomic, strong) NSArray *monthExpenseArray;
@property (nonatomic, strong) NSArray *montIncomehArray;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title  = @"";
    self.title = @"账单";
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.choseYear = [Tool getDate:[NSDate date] dateType:@"YYYY"];
    self.choseMonth = [Tool getDate:[NSDate date] dateType:@"MM"];

   
    self.monthExpenseArray = [self accordingToType:NO];
    self.montIncomehArray = [self accordingToType:YES];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailIdentifier"];
    
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"DetailView" owner:self options:nil] lastObject];
    self.headView.useData = self.useData;
    
    __weak typeof(self) weakSelf = self;
    self.headView.tapChoseTypeBlock = ^(BOOL choseType) {
        weakSelf.choseType = choseType;
        [weakSelf.tableView reloadData];
    };
    self.headView.tapDateBlock = ^(NSInteger year, NSInteger month) {
        weakSelf.choseYear = year;
        weakSelf.choseMonth = month;
        weakSelf.monthExpenseArray = [weakSelf accordingToType:NO];
        weakSelf.montIncomehArray = [weakSelf accordingToType:YES];
        [ weakSelf.headView setExpense:[NSString stringWithFormat:@"支出%ld笔 共支出%.2f元",weakSelf.monthExpenseArray.count,[weakSelf totalMoney:weakSelf.monthExpenseArray]] income:[NSString stringWithFormat:@"收入%ld笔 共入账%.2f元",weakSelf.montIncomehArray.count,[weakSelf totalMoney:weakSelf.montIncomehArray]] choseDateYear: weakSelf.choseYear choseDatemonth:weakSelf.choseMonth];
        [weakSelf.tableView reloadData];
    };
    self.headView.frame = CGRectMake(20, 0, self.tableView.frame.size.width-40, 210);
    [ self.headView setExpense:[NSString stringWithFormat:@"支出%ld笔 共支出%.2f元",self.monthExpenseArray.count,[self totalMoney:self.monthExpenseArray]] income:[NSString stringWithFormat:@"收入%ld笔 共入账%.2f元",self.montIncomehArray.count,[self totalMoney:self.montIncomehArray]] choseDateYear: self.choseYear choseDatemonth: self.choseMonth];
    self.tableView.tableHeaderView =  self.headView;

    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];

}
-(float)  totalMoney:(NSArray *) array{
    float tempT = 0;
    for (RecordModel *recordTemp in array) {
        tempT +=recordTemp.money;
    }
    return  tempT;
}
#pragma mark - 遍历数据
-(NSArray *) accordingToType:(BOOL) type {
    NSMutableArray *monthAllTemp  = [[NSMutableArray alloc] init];
    
    for (ThisYearDataModel *yearTemp in self.useData.allRecordArray) {
        if (self.choseYear  == yearTemp.recordYearDate) {
            monthArray = yearTemp.thisYearRecord;
            for (ThisMonthDataModel *monthTemp in yearTemp.thisYearRecord) {
                if (self.choseMonth == monthTemp.recordMonthDate) {
                    dayArray = monthTemp.thisMonthAllRecord;
                    for (ThisDayDataModel *dayTemp in monthTemp.thisMonthAllRecord) {
                        for (RecordModel *recordTemp in dayTemp.thisDayAllRecord) {
                            if (recordTemp.recordType == type) {
                                //收入
                                [monthAllTemp addObject:recordTemp];
                            }
                        }
                    }
                    break;
                }
                
            }
        }
    }
    return monthAllTemp;
    
}
//合并相同model的数据
-(NSMutableArray *)distinguishArrayWithArray:(NSArray *)dataSource
{
    
    //初始化一个空数组 用于return
    NSMutableArray *array = [NSMutableArray arrayWithArray:dataSource];
    
    NSMutableArray *dateMutablearray = [@[] mutableCopy];
    for (int i = 0; i < array.count; i ++) {
        
        RecordModel *mo = array[i];
        RecordModel *tempRecord = [[RecordModel alloc] init];
        tempRecord.type = mo.type;
        tempRecord.typeName = mo.typeName;
        tempRecord.money = mo.money;
        for (int j = i+1; j < array.count; j ++) {
            RecordModel *tmpmo = array[j];
            if([mo.type isEqualToString:tmpmo.type]){
                tempRecord.money += tmpmo.money;
                [array removeObjectAtIndex:j];
                j -= 1;
                
            }
            
        }
        
        [dateMutablearray addObject:tempRecord];
        
    }
    
    return dateMutablearray;
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 240;

    }
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;

    }else{
        if (_choseType == YES) {
            return self.montIncomehArray.count;

        }else{
            return self.monthExpenseArray.count;

        }
    }
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==  1) {
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailIdentifier"];
        RecordModel *temp;

        if (_choseType == YES) {
            temp =  self.montIncomehArray[indexPath.row];

        }else{
            temp =  self.monthExpenseArray[indexPath.row];

        }
      
        [cell loadThisView:temp indexPath:2];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier1"];
        }
        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell addSubview:[self showDataPNPieChart]];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
   
    
}
#pragma mark - 扇形图的现实
-(UIView *) showDataPNPieChart{
    UIView *blakeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_Screen_Width-40, 240)];
    blakeView.backgroundColor = [UIColor whiteColor];
    if (_choseType == YES) {
        monthTypeArray = [self distinguishArrayWithArray: self.montIncomehArray];

    }else{
        monthTypeArray = [self distinguishArrayWithArray: self.monthExpenseArray];

    }
    NSMutableArray *tempitems = [[NSMutableArray alloc] init];
    for (RecordModel *tempM in monthTypeArray) {
        [tempitems addObject: [PNPieChartDataItem dataItemWithValue:tempM.money color:[UIColor colorNamed:tempM.type] description:tempM.typeName]];
    }
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((k_Screen_Width-40)/2-100, 20, 200, 200) items:tempitems];
    pieChart.enableMultipleSelection =YES;
    pieChart.delegate = self;
    [pieChart strokeChart];
    // 加到父视图上
//    [self.view addSubview:pieChart];
    // 显示图例
    pieChart.hasLegend = YES;
    // 横向显示
    pieChart.legendStyle = PNLegendItemStyleSerial;
    // 显示位置
    pieChart.legendPosition = PNLegendPositionTop;
    // 获得图例 当横向排布不下另起一行
    [blakeView addSubview:pieChart];
    return blakeView;
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

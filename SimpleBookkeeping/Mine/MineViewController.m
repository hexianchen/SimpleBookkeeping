//
//  MineViewController.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/15.
//

#import "MineViewController.h"
#import "MineDetailViewController.h"
#import "LoginViewController.h"
#import "UserDataModel.h"
#import <objc/message.h>
#import "SetBudgetSurplusVC.h"
#import "FeedbackViewController.h"
#import "HumanBooksViewController.h"
#import "HumanBooksModel.h"
#import "TimeTool.h"
@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**属性名称*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MineViewController
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.topItem.title = @"";
    NSLog(@"%@",[BmobUser currentUser]);

    
    _dataArray = @[@[@"未登录"],@[@"预算设置",@"年度报表",@"分类报表",@"人情账本"],@[@"求助反馈",@"关于记账本",@"退出"]];
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor  =  grayBaseColor;
    self.tableView.backgroundView.backgroundColor = grayBaseColor;
    _tableView.tableFooterView = footView;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *a= _dataArray[section];
    return a.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Identifier"];
    }
    if (indexPath.section==0) {
        BmobUser *useInfo =[BmobUser currentUser];
        if ( useInfo !=nil) {
            UIImage *icon = [UIImage imageNamed:@"head3"];
            CGSize itemSize = CGSizeMake(60, 60);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [icon drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.textLabel.text = useInfo.username;
            cell.textLabel.font = [UIFont systemFontOfSize:20];
            cell.detailTextLabel.text = useInfo.mobilePhoneNumber;
        }else{
            cell.imageView.image = [UIImage imageNamed:@"isLogin"];
            cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:20];
            cell.detailTextLabel.text = @"点击头像登录";
        }
        
    }else{
        cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];

    }
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];

    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  10;;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }
    return 60;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if ([BmobUser currentUser] != nil){
                MineDetailViewController *mineDetail = [[MineDetailViewController alloc] init];
                [self.navigationController pushViewController:mineDetail animated:YES];
            }else{
                LoginViewController *login = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:login animated:YES];
            }
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:
                {
                    SetBudgetSurplusVC *vc = [[SetBudgetSurplusVC alloc] init];
                    vc.userdataModel = self.userdataModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {
                    HumanBooksViewController *vc = [[HumanBooksViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;

                    
                default:
                    break;
            }
        }
            
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:
                {
                    FeedbackViewController *vc = [[FeedbackViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    //退出登录的操作 ，并且更新数据操作
                    BmobObject  *dataChange = [BmobObject objectWithoutDataWithClassName:@"RecordData" objectId:[[BmobUser currentUser] objectForKey:@"recordId"]];
                    dataChange = [self dataToDictionary:dataChange];
                    
                    [dataChange updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            NSLog(@"%d",isSuccessful);
                        } else {
                        }
                    }];
                   
                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[BmobUser currentUser].username message:@"亲爱的用户，您确定要退出当前账号吗？～" preferredStyle:UIAlertControllerStyleAlert];
                        //默认只有标题 没有操作的按钮:添加操作的按钮 UIAlertAction
                        
                        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            //清除本地数据
                            [Tool removeDataPathString:userRecordPathName];
                            [Tool removeDataPathString:userRecordHumanBoosksPathName];
                            //退出登录
                            [BmobUser logout];
                            [self.navigationController popViewControllerAnimated:YES];

                            NSLog(@"退出登录");
                        }];
                        //添加确定
                        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"保持登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
                            NSLog(@"保持登录");
                        }];
                        //设置`确定`按钮的颜色
                        [sureBtn setValue:ExpenseColor forKey:@"titleTextColor"];
                        //将action添加到控制器
                        [alertVc addAction:cancelBtn];
                        [alertVc addAction :sureBtn];
                        //展示
                        [self presentViewController:alertVc animated:YES completion:nil];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            
            break;
        default:
            break;
    }
}

//获取全部数据并转为字典，进行保存
-(BmobObject *) dataToDictionary:(BmobObject *)object {
    NSData *data = [Tool readLocalDataPathString:userRecordPathName];
    UserDataModel *user=[NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[RecordModel class],[ThisDayDataModel class],[ThisMonthDataModel class],[ThisYearDataModel class],[UserDataModel class],[NSArray class],[NSDate class] ,nil] fromData:data error:nil];
    NSMutableArray *allTemp  = [[NSMutableArray alloc] init];
    for (ThisYearDataModel *yearTemp in user.allRecordArray) {
        for (ThisMonthDataModel *monthTemp in yearTemp.thisYearRecord) {
            for (ThisDayDataModel *dayTemp in monthTemp.thisMonthAllRecord) {
                for (RecordModel *recordTemp in dayTemp.thisDayAllRecord) {
                    [allTemp addObject:[recordTemp dicFromObject]];
                
                }
            }
        }
    }
    [object setObject:allTemp forKey:@"allRecord"];
    
    //读取文件
    NSData *readData = [Tool readLocalDataPathString:userRecordHumanBoosksPathName];
    HumanBooksModel *humanBooks =  [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[HumanBooksModel class],[RecordHumanBooksModel class],[NSDate class],[NSMutableArray class] ,nil] fromData:readData error:nil];
    NSMutableArray *tempAray = [NSMutableArray new];
    for(RecordHumanBooksModel *temp in humanBooks.giftsArray){
        NSMutableDictionary *dic =  [NSMutableDictionary dictionaryWithDictionary: [temp dictionaryWithValuesForKeys:@[@"name",@"giftType",@"money",@"matter",@"remark",@"recordDate"]]];
        dic[@"recordDate"] = [TimeTool dateToString:temp.recordDate];
        [tempAray addObject:dic];
    }
    [object setObject:tempAray forKey:@"allHumaBooksRecord"];
    return object;
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

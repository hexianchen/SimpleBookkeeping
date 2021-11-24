//
//  RecordHumanBooksVC.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/31.
//

#import "RecordHumanBooksVC.h"
#import "TimeTool.h"
@interface RecordHumanBooksVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    RecordHumanBooksModel *recordModel;
    NSMutableArray *dataArray;
    NSArray *allDataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSemented;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matterSemented;
@property (weak, nonatomic) IBOutlet UIDatePicker *choseDate;
@property (weak, nonatomic) IBOutlet UITextField *remarkText;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@end

@implementation RecordHumanBooksVC
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"将要离开");
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getData];
 
}
- (void) getData{
    
    //读取文件
    NSData *readData = [Tool readLocalDataPathString:userRecordHumanBoosksPathName];
    HumanBooksModel *humanBooks =  [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[HumanBooksModel class],[RecordHumanBooksModel class],[NSDate class],[NSMutableArray class] ,nil] fromData:readData error:nil];
    allDataArray = [NSArray arrayWithArray: humanBooks.giftsArray];
}
- (IBAction)tapDismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
- (IBAction)tapSaveButton:(id)sender {
    if (self.nameText.text.length == 0) {
//        [Tool showError:@"姓名不能为空"];
        [HXCMBProgressHUD showMessage:@"姓名不能为空"];
        return;
    }
    if (self.moneyText.text.length == 0) {
//        [Tool showError:@"礼金不能为空"];

        [HXCMBProgressHUD showMessage:@"礼金不能为空"];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    if (recordModel == nil) {
        recordModel = [[RecordHumanBooksModel alloc] init];
    }
    recordModel.name = self.nameText.text;
    recordModel.money = [NSNumber numberWithFloat:[self.moneyText.text floatValue]];
    
    if( self.typeSemented.selectedSegmentIndex  ==0){
        recordModel.giftType = @"give";
    }else{
        recordModel.giftType = @"receiving";

    }
    recordModel.recordDate = self.choseDate.date;
    switch (self.matterSemented.selectedSegmentIndex) {
        case 0:
            recordModel.matter = @"结婚" ;

            break;
        case 1:
            recordModel.matter = @"满月" ;

            break;
        case 2:
            recordModel.matter = @"搬家" ;

            break;
        case 3:
            recordModel.matter = @"丧事" ;

            break;
        case 4:
            recordModel.matter = @"其他" ;

            break;
           
        default:
            break;
    }
    recordModel.remark = self.remarkText.text;
    
    if([self.delegate respondsToSelector:@selector(tapDisMissView:)]){
        [self.delegate tapDisMissView:recordModel];
    }
}
-(void) textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.nameText]) {
        dataArray = [[NSMutableArray alloc]init];
        for (RecordHumanBooksModel *temp in allDataArray) {
            if ([self.nameText.text isEqualToString:temp.name]) {
                [dataArray addObject:temp];
            }
        }
        if (dataArray.count>0) {
            [self.tableView reloadData];
            [self.nameText resignFirstResponder];

            return;

        }
    }
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameText resignFirstResponder];
    [self.remarkText resignFirstResponder];
    [self.moneyText resignFirstResponder];


}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellTableIndentifier = @"RecordHumanBooksCell";
        //单元格ID
        //重用单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
    //初始化单元格
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIndentifier];
    }
    RecordHumanBooksModel *temp = dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@礼:  %.2f",[temp.giftType isEqualToString:@"give"]?@"送":@"收", [temp.money floatValue]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"事由：%@ 时间：%@ 备注：%@",temp.matter,[TimeTool dateToString:temp.recordDate typeString:@"yyyy-MM-dd"],temp.remark];
    return cell;
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

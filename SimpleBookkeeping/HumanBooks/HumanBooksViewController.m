//
//  HumanBooksViewController.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/29.
//

#import "HumanBooksViewController.h"
#import "HumanBooksCell.h"
#import "HumanBooksHeaderView.h"
#import "RecordHumanBooksVC.h"
#import "HumanBooksModel.h"
#import "TimeTool.h"
@interface HumanBooksViewController ()<UITableViewDelegate,UITableViewDataSource,RecordHumanBooksVCDalegate>{
    HumanBooksHeaderView *headerView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HumanBooksModel *humanBooks;
@property (strong, nonatomic) NSMutableArray *showArray;
@end

@implementation HumanBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置预估行高
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view from its nib.
    headerView  =  [[NSBundle mainBundle] loadNibNamed:@"HumanBooksViewController" owner:self options:nil][1];
    self.tableView.tableHeaderView = headerView;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self rightBtnSava];
    [self getData];
}
- (void)rightBtnSava{

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame=CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(5, 166, 5, 0)];
    [rightButton addTarget:self action:@selector(addhumanBooks) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    nagetiveSpacer.width = -10;//这个值可以根据自己需要自己调整

    self.navigationItem.rightBarButtonItems = @[nagetiveSpacer, rightBar];

}
-(void) addhumanBooks{
    RecordHumanBooksVC *vc = [[RecordHumanBooksVC alloc] init];
    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}
//获取本地的数据
- (void) getData{
    self.showArray = [NSMutableArray new];
    //读取文件
    NSData *readData = [Tool readLocalDataPathString:userRecordHumanBoosksPathName];
    self.humanBooks =  [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[HumanBooksModel class],[RecordHumanBooksModel class],[NSDate class],[NSMutableArray class] ,nil] fromData:readData error:nil];
    if (self.humanBooks ==nil) {
        self.humanBooks = [[HumanBooksModel alloc] init];
    }
    for (RecordHumanBooksModel *temp in self.humanBooks.giftsArray) {
        BOOL isExist = NO;
        for (ShowHumanBooksModel *showTemp in self.showArray) {
            if ([temp.name isEqualToString:showTemp.name]) {
                isExist = YES;
                if ([temp.giftType isEqualToString:@"give"]) {
                    [showTemp.giveGiftsArray addObject:temp];
                }else{
                    [showTemp.receivingGiftsArray addObject:temp];
                }
                break;
            }
        }
        if (isExist == NO) {
            ShowHumanBooksModel *showModel = [[ShowHumanBooksModel alloc] init];
            showModel.name = temp.name;
            showModel.giveGiftsArray = [[NSMutableArray alloc] init];
            showModel.receivingGiftsArray = [[NSMutableArray alloc] init];
            if ([temp.giftType isEqualToString:@"give"]) {
                [showModel.giveGiftsArray addObject:temp];
            }else{
                [showModel.receivingGiftsArray addObject:temp];
            }
            [self.showArray addObject:showModel];
        }
    }
    if (self.showArray.count == 0) {
        UIView *back = [[UIView alloc] initWithFrame:self.view.bounds];
        UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(back.frame.size.width/2-100, back.frame.size.height/2-65, 200, 130)];
        [backImageView setImage:[UIImage imageNamed:@"noData"]];
        [back addSubview:backImageView];
        self.tableView.backgroundView = back;
    }else{
        self.tableView.backgroundView = nil;

    }
    [self.tableView reloadData];
    [headerView setHeaderViewData:self.humanBooks];
}
-(void) tapDisMissView:(RecordHumanBooksModel *)recordModel{
    BOOL isExist = NO;
    for (ShowHumanBooksModel *showTemp in self.showArray) {
        if ([recordModel.name isEqualToString:showTemp.name]) {
            isExist = YES;
            if ([recordModel.giftType isEqualToString:@"give"]) {
                [showTemp.giveGiftsArray addObject:recordModel];
            }else{
                [showTemp.receivingGiftsArray addObject:recordModel];
            }
            break;
        }
    }
    if (isExist == NO) {
        ShowHumanBooksModel *showModel = [[ShowHumanBooksModel alloc] init];
        showModel.name = recordModel.name;
        showModel.giveGiftsArray = [[NSMutableArray alloc] init];
        showModel.receivingGiftsArray = [[NSMutableArray alloc] init];
        if ([recordModel.giftType isEqualToString:@"give"]) {
            [showModel.giveGiftsArray addObject:recordModel];
        }else{
            [showModel.receivingGiftsArray addObject:recordModel];
        }
        [self.showArray addObject:showModel];
    }
    [self.tableView reloadData];
    [self.humanBooks.giftsArray addObject:recordModel];
    [headerView setHeaderViewData:self.humanBooks];
    [Tool saveLocalData:self.humanBooks pathNameString:userRecordHumanBoosksPathName];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showArray.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellTableIndentifier = @"HumanBooksCell";
        //单元格ID
        //重用单元格
    HumanBooksCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
    //初始化单元格
    if(cell == nil)
    {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:CellTableIndentifier owner:self options:nil];
        //xib文件
        cell = [nib objectAtIndex:0] ;
    }
    [cell setCellData:self.showArray[indexPath.row]];
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
@implementation ShowHumanBooksModel
@end

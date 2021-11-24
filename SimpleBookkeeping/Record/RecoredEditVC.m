//
//  ExpenseVC.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/11.
//

#import "RecoredEditVC.h"
#import <Masonry/Masonry.h>
#import "TypeCollectionViewCell.h"
#import "SortManagementVC.h"
@interface RecoredEditVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>{
    UITextField *remarkText;
    UIView *line;
    NSMutableArray *typeArray;
    RecordTypeModel *choseType; // 选择的支出类型
    UICollectionView *collectionView;
}
@property (nonatomic, strong) UILabel *moneyL;
@property (nonatomic, strong) NSMutableString *moneyString;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation RecoredEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
//    self setEdgesForExtendedLayout:(UIRectEdge)
    self.view.backgroundColor = [UIColor whiteColor];
    [self initCollectionView];
    [self getTypeArray];
        [self keyBoardView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //实现该方法是需要注意view需要是继承UIControl而来的
}
-(void) getTypeArray{
    typeArray = [self getTyprData:self.recordType];
    if(self.choseRecord){
        choseType = [[RecordTypeModel alloc] init];
        choseType.iconImg = self.choseRecord.iconImg;
        choseType.number = self.choseRecord.number;
        choseType.recordType = self.choseRecord.recordType;
        choseType.type = self.choseRecord.type;
        choseType.typeName = self.choseRecord.typeName;
    }else{
        choseType = [typeArray firstObject];
    }
    if (choseType.recordType) {
        _moneyL.textColor = incomeColor;
        line.backgroundColor = incomeColor;
    }else{
        _moneyL.textColor = ExpenseColor;
        line.backgroundColor = ExpenseColor;
    }
    [collectionView reloadData];
    
}
 - (void)initCollectionView{

     CGFloat x = 0;
     CGFloat y = 100;
     CGFloat width = self.view.frame.size.width;
     CGFloat height = 230;
     
     // 创建一个显示View
     
     [self.view addSubview:({
         line = [[UIView alloc] initWithFrame:CGRectMake(20, 80, width, 2)];
         line.backgroundColor = ExpenseColor;
         line;
     })];
     
     
     self.moneyL = [[UILabel alloc] init];
     self.moneyL.textAlignment = NSTextAlignmentLeft;
     self.moneyL.text = self.moneyString;
     self.moneyL.font = [UIFont fontWithName:@"ArialMT" size:50];
     self.moneyL.textColor = ExpenseColor;
     [self.view addSubview: self.moneyL];
     
     [self.moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(20);
         make.right.mas_equalTo(20);
         make.top.mas_equalTo(self.view).offset(20);
         make.height.mas_offset(40);
     }];
   
     
     //创建布局对象
     UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
     //设置滚动方向为垂直滚动，说明方块是从左上到右下的布局排列方式
     layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//     //设置顶部视图和底部视图的大小，当滚动方向为垂直时，设置宽度无效，当滚动方向为水平时，设置高度无效
//     layout.headerReferenceSize = CGSizeMake(100, 40);
//     layout.footerReferenceSize = CGSizeMake(100, 40);
     //创建容器视图
     CGRect frame =CGRectMake(x, y, width, height);
     collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
     //设置代理
     collectionView.delegate = self;
     collectionView.dataSource = self;
     collectionView.backgroundColor = [UIColor systemGray6Color];;//设置背景，默认为黑色
     
     [self.view addSubview:collectionView];
     [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TypeCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TypeCollectionViewCellID"];
     
     self.datePicker = [[UIDatePicker alloc] init];
     self.datePicker.tintColor = [UIColor blackColor];
     [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
     self.datePicker.datePickerMode=UIDatePickerModeDateAndTime;
     [self.view addSubview:self.datePicker];

      if (@available(iOS 14.0, *)) {
         self.datePicker.preferredDatePickerStyle = UIDatePickerStyleCompact;
          [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.mas_equalTo(collectionView.mas_bottom).mas_offset(5);
              make.left.mas_equalTo(self.view).offset(10);
              make.right.mas_equalTo(self.view);
              make.height.mas_equalTo(60);
          }];
      } else {
          [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.mas_equalTo(collectionView.mas_bottom).mas_offset(5);
              make.left.mas_equalTo(self.view).offset(10);
              make.right.mas_equalTo(self.view);
              make.height.mas_equalTo(200);
          }];
      }
    remarkText = [[UITextField alloc] init];
     remarkText.placeholder = @"  请输入备注内容";
     remarkText.delegate = self;
     [self.view addSubview:remarkText];
     
     remarkText.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"remark"]];
     [remarkText mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.datePicker.mas_bottom).mas_offset(10);
         make.left.mas_equalTo(self.view).mas_offset(10);
         make.right.mas_equalTo(self.view).mas_offset(-10);
         make.height.mas_equalTo(40);
     }];
     UIView *line1;
     [remarkText addSubview:({
         line1 = [[UIView alloc] init];
         line1.backgroundColor = [UIColor systemGray5Color];
         line1;
     })];
     [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(remarkText.mas_bottom);
         make.left.mas_equalTo(remarkText);
         make.right.mas_equalTo(remarkText);
         make.height.mas_equalTo(2);
     }];
     UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
     leftImgView.image = [UIImage imageNamed:@"remark"];
     leftImgView.contentMode = UIViewContentModeScaleAspectFit;
     remarkText.leftView = leftImgView;
     remarkText.leftViewMode = UITextFieldViewModeAlways;
     
     if(self.choseRecord){
         [self creatRightBtn];
     }
}

#pragma mark - 右侧的删除按钮创建并初始化数据
- (void)creatRightBtn{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame=CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(5, 166, 5, 0)];
    [rightButton addTarget:self action:@selector(deleteButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -10;//这个值可以根据自己需要自己调整
    self.navigationItem.rightBarButtonItems = @[nagetiveSpacer, rightBar];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    self.moneyL.text = [NSString stringWithFormat:@"%.2f" ,self.choseRecord.money];
    self.moneyString = [NSMutableString stringWithString: self.moneyL.text];
    self.datePicker.date  =  self.choseRecord.time;
    remarkText.text =  [NSString stringWithFormat:@"%@" ,self.choseRecord.remark];
    
}
-(void) deleteButton{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[BmobUser currentUser].username message:@"亲爱的用户，您确定要删除该条数据吗？删除后无法恢复～" preferredStyle:UIAlertControllerStyleAlert];
        //默认只有标题 没有操作的按钮:添加操作的按钮 UIAlertAction
        
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
        //添加确定
    __weak typeof(self) weakSelf = self;
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
        weakSelf.backRecordBlock(weakSelf.choseRecord, 3);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    //设置`确定`按钮的颜色
    [sureBtn setValue:ExpenseColor forKey:@"titleTextColor"];
    //将action添加到控制器
    [alertVc addAction:cancelBtn];
    [alertVc addAction :sureBtn];
    //展示
    [self presentViewController:alertVc animated:YES completion:nil];
}
// 创建键盘视图
- (void ) keyBoardView{
    UIView *keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height- 185-20-88, self.view.frame.size.width, 185)];
    
    keyBoardView.backgroundColor = [UIColor systemGray6Color];
    
    [self.view addSubview:keyBoardView];
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@".",@"del",@"确定"];
    float weith  = (keyBoardView.frame.size.width-25)/4;
    float h = 40;
    for (int x = 0; x<4; x++) {
        for (int y = 0; y<4; y++) {
            if (x < 3 && y<3) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(y*weith+5*(y+1), x*h+5*(x+1), weith, h)];
                [btn addTarget:self action:@selector(keyborldChose:) forControlEvents:UIControlEventTouchUpInside];
                               [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitle:array[x*3+y] forState:UIControlStateNormal];
                btn.showsTouchWhenHighlighted = YES;
                [keyBoardView addSubview:btn];
            }
            if (x==3 &&y == 0) {
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(y*weith+5*(y+1), x*h+5*(x+1), weith*2+5, h)];
                btn.tag = 100;
                btn.showsTouchWhenHighlighted = YES;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitle:array[9] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(keyborldChose:) forControlEvents:UIControlEventTouchUpInside];
                [keyBoardView addSubview:btn];
            }
            if (x==3 &&y == 2) {

                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(y*weith+5*(y+1), x*h+5*(x+1), weith, h)];
                btn.tag = 101;
                btn.showsTouchWhenHighlighted = YES;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitle:array[10] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(keyborldChose:) forControlEvents:UIControlEventTouchUpInside];

                [keyBoardView addSubview:btn];
            }
            if (x==0 &&y == 3) {
                //删除按钮
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(y*weith+5*(y+1), x*h+5*(x+1), weith, h)];
                btn.tag = 102;
                btn.showsTouchWhenHighlighted = YES;
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTintColor:[UIColor blackColor]];
                [btn setImage:[UIImage systemImageNamed:@"delete.left"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(keyborldChose:) forControlEvents:UIControlEventTouchUpInside];
                [keyBoardView addSubview:btn];
            }
            if (x==1 &&y == 3) {
                //确定按钮
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(y*weith+5*(y+1), x*h+5*(x+1), weith, h*3+10)];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitle:array[12] forState:UIControlStateNormal];
                btn.tag = 103;
                btn.showsTouchWhenHighlighted = YES;
                [btn addTarget:self action:@selector(keyborldChose:) forControlEvents:UIControlEventTouchUpInside];
                [keyBoardView addSubview:btn];
            }
        }
    }
    
}
-(void) keyborldChose:(UIButton *)button{
    if (!self.moneyString) {
        self.moneyString = [[NSMutableString alloc] initWithString:@"0"];

    }
    switch(button.tag) {
        case  100:
            //点击“0”
            if(self.moneyString.length - [self.moneyString rangeOfString:@"."].location == 3){
                break;
                
            }else if  ([self.moneyString isEqualToString:@"0."]||[self.moneyString isEqualToString:@"0.0"]) {
                [self.moneyString appendString:button.titleLabel.text];
            }else if ( [self.moneyString  floatValue]  !=  0) {
                [self.moneyString appendString:button.titleLabel.text];
;
            }
            break;
        case  101:{
            //点击“.”
            if (![self.moneyString containsString:@"."]) {
                [self.moneyString appendString:@"."];
            }
            break;
        }
        case  102:{
            //删除按钮
            if ([self.moneyString isEqualToString:@"0"]) {
                break;
            }else {
                if (self.moneyString.length==1) {
                    [self.moneyString replaceCharactersInRange:NSMakeRange(self.moneyString.length-1, 1) withString:@"0"];
                }else{
                        [self.moneyString deleteCharactersInRange:NSMakeRange(self.moneyString.length-1, 1)];
                }
            }
            break;
        }
        case  103:{
            if ([self.moneyString floatValue] == 0||[self.moneyString characterAtIndex:self.moneyString.length-1] == '.') {
                [HXCMBProgressHUD showMessage:@"请输入具体金额"];
                return;
            }
            //记账一笔
            RecordModel *recordData = [[RecordModel alloc] init];
            recordData.iconImg = choseType.iconImg;
            recordData.number = choseType.number;
            recordData.recordType =choseType.recordType;
            recordData.type = choseType.type;
            recordData.typeName = choseType.typeName;
            recordData.money = [self.moneyString floatValue];
            recordData.time = self.datePicker.date ;
            if (remarkText.text.length != 0 ) {
                recordData.remark =  [NSString stringWithFormat:@"%@" ,remarkText.text];
            }
            if (self.choseRecord) {
                recordData.ID = self.choseRecord.ID;
                self.backRecordBlock(recordData, 2);
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                self.backRecordBlock(recordData, 1);
                for (UIView* next = [self.view superview];next;next = next.superview) {
                       UIResponder *nextResponder = [next nextResponder];
                       if ([nextResponder isKindOfClass:[UIViewController class]]) {
                           UIViewController *tempVC = (UIViewController *)nextResponder;
                            [tempVC.navigationController popViewControllerAnimated:YES];
                           break;
                       }
                   }
            }
            break;
        }
        default:{
            if(self.moneyString.length - [self.moneyString rangeOfString:@"."].location == 3){
                break;
                
            }else if ([self.moneyString isEqualToString:@"0."]||[self.moneyString isEqualToString:@"0.0"]) {
                [self.moneyString appendString:button.titleLabel.text];
            }else if ([self.moneyString isEqualToString:@"0"]) {
                self.moneyString = [NSMutableString stringWithString: button.titleLabel.text];
            }else{
                [self.moneyString appendString:button.titleLabel.text];

            }
        }
            break;
    }
    self.moneyL.text = self.moneyString;
    
}
#pragma mark -UITextFildDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];

}
#pragma mark - UICollectionViewDelegateFlowLayout

/* 设置各个方块的大小尺寸 */
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
 

    CGFloat width = collectionView.frame.size.width/7;

    CGFloat height = 100;

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
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return typeArray.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TypeCollectionViewCellID" forIndexPath:indexPath];
    if (typeArray.count == indexPath.row) {
        //设置按钮
        cell.typeNameLable.text = @"设置";
        cell.imgView.image = [UIImage imageNamed:@"shezi"];
        cell.typeNameLable.textColor = [UIColor grayColor];

    }else{
        RecordTypeModel *temp = typeArray[indexPath.row];
        if ([choseType.type isEqualToString:temp.type] ) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Select",temp.iconImg]];
            cell.typeNameLable.textColor = [UIColor blackColor];
        }else{
            cell.imgView.image = [UIImage imageNamed:temp.iconImg];
            cell.typeNameLable.textColor = [UIColor grayColor];
        }
        cell.typeNameLable.text = temp.typeName;
    }
    
    
    
    return cell;
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (typeArray.count == indexPath.row) {
        SortManagementVC *vc = [[SortManagementVC alloc] init];
        vc.recordType = self.recordType;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (ChangeNameNotification:) name:@ "ChangeNameNotification" object:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        RecordTypeModel *temp = typeArray[indexPath.row];
        choseType  = temp;
        [collectionView reloadData];
    }
    
}
-(void)ChangeNameNotification:(NSNotification*)notification{
    NSArray *temp =notification.userInfo[@"typeArray"];
    NSMutableArray *tempArray = [NSMutableArray new];
    BOOL isExist = NO;
    for (int i=0; i<temp.count; i++) {
        RecordTypeModel *record = temp[i];
        record.number = i+1;
        [tempArray addObject:record];
        if ([choseType.type isEqualToString: record.type]) {
            isExist = YES;
        }
        
    }
    typeArray = tempArray;

    if (!isExist) {
        choseType  = [typeArray firstObject];
    }
    [collectionView setContentOffset:CGPointMake(0,0) animated:NO];

    [collectionView reloadData];
    
}

- (NSMutableArray *) getTyprData:(BOOL) recordType{
    NSArray *getDataArray;
    //获取程序的type文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PropertyList" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    //获取应用沙盒的Douch
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* plist1 = [paths objectAtIndex:0];
    //获取一个plist文件
    NSString* filename = [plist1 stringByAppendingString:@"PropertyList.plist"];
    NSMutableArray *userArray = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    if (userArray.count ==0 ) {
        [array writeToFile:filename atomically:YES];
        getDataArray = array;
    }else{
        getDataArray = userArray;
    }
    
    NSMutableArray *tempMArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in getDataArray) {
        RecordTypeModel *tempModel = [[RecordTypeModel alloc] initWithDictionary:dic];
        if(tempModel.recordType == recordType){
            [tempMArray addObject:tempModel];
        }
    }
    //排序
    [tempMArray sortUsingComparator:^NSComparisonResult(RecordModel *obj1, RecordModel *obj2) {
        return [@(obj1.number) compare:@(obj2.number)];
    }];
    return tempMArray;
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

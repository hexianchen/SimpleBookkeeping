//
//  RecordMoneyViewController.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/11.
//

#import "RecordMoneyViewController.h"
#import <Masonry/Masonry.h>

@interface RecordMoneyViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *incomeBtn;
@property (nonatomic, strong) UIButton *expenseBut;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic, strong) UIView *centerView;
@end

@implementation RecordMoneyViewController
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.centerView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setTranslucent:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (ChangeNameNotification:) name:@ "ChangeNameNotification" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.recordEditVC.view.frame = CGRectMake(0, 0, k_Frame_Width, k_Frame_Height);
    self.recordEditVC.recordType = NO;
    [self.view addSubview:self.recordEditVC.view];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"multiply"] style:UIBarButtonItemStylePlain target:self action:@selector(popView)];
    backItem.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = backItem;
    self.centerView = [[UIView alloc] init];
    [self.navigationController.navigationBar addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(44);
        make.width.mas_offset(100);
        make.center.mas_equalTo(self.navigationController.navigationBar);
    }];
    self.selectIndex = 0;
    self.expenseBut = [[UIButton alloc] init];
    self.expenseBut.frame = CGRectMake(0, 0, 50, 30);
    [self.expenseBut setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.expenseBut setTitle:@"支出" forState:UIControlStateNormal];
    [self.expenseBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.expenseBut.selected = YES;
    [self.expenseBut addTarget:self action:@selector(selectIncomeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView addSubview:self.expenseBut];

    self.selectView = [[UIView alloc] initWithFrame:CGRectMake(5, 35, 40, 4)];
    self.selectView.backgroundColor = [UIColor blackColor];
    [self.centerView addSubview:self.selectView];
    
    
    self.incomeBtn = [[UIButton alloc] init];
    self.incomeBtn.frame = CGRectMake(50, 0, 50, 30);
    [self.incomeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.incomeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    self.incomeBtn.selected = NO;
    [self.incomeBtn addTarget:self action:@selector(selectIncomeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.incomeBtn setTitle:@"收入" forState:UIControlStateNormal];
    
    [self.centerView addSubview:self.incomeBtn];
    UISwipeGestureRecognizer * recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizerRight];

    UISwipeGestureRecognizer * recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];

    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizerLeft];
    self.incomeBtn.enabled = YES;
    self.expenseBut.enabled = NO;
    self.selectView.backgroundColor = ExpenseColor;
}

-(void) popView{
    [self.centerView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) selectIncomeBtn{
    self.incomeBtn.selected = !self.incomeBtn.selected;
    self.expenseBut.selected = !self.expenseBut.selected;
    if (self.incomeBtn.selected) {
        __weak typeof(self) weakSelf = self;
        self.incomeBtn.enabled = NO;
        self.expenseBut.enabled = YES;
        self.recordEditVC.recordType = YES;
        [self.recordEditVC getTypeArray];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.selectView.frame  = CGRectMake(55, 35, 40, 4);
            weakSelf.selectView.backgroundColor = incomeColor;
        }];
        
    }else{
        __weak typeof(self) weakSelf = self;
        self.incomeBtn.enabled = YES;
        self.expenseBut.enabled = NO;
        self.recordEditVC.recordType = NO;
        [self.recordEditVC getTypeArray];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.selectView.frame  = CGRectMake(5, 35, 40, 4);
            weakSelf.selectView.backgroundColor = ExpenseColor;

        }];
        
    }
    
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft && !self.expenseBut.selected) {
        NSLog(@"swipe left");
        self.incomeBtn.selected = !self.incomeBtn.selected;
        self.expenseBut.selected = !self.expenseBut.selected;
        __weak typeof(self) weakSelf = self;
        self.recordEditVC.recordType = NO;
        self.incomeBtn.enabled = YES;
        self.expenseBut.enabled = NO;
        [self.recordEditVC getTypeArray];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.selectView.frame  = CGRectMake(5, 35, 40, 4);
            weakSelf.selectView.backgroundColor = ExpenseColor;

        }];
        
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight && !self.incomeBtn.selected) {
      NSLog(@"swipe right");
        self.incomeBtn.selected = !self.incomeBtn.selected;
        self.expenseBut.selected = !self.expenseBut.selected;
        __weak typeof(self) weakSelf = self;
        self.incomeBtn.enabled = NO;
        self.expenseBut.enabled = YES;
        self.recordEditVC.recordType = YES;
        [self.recordEditVC getTypeArray];

        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.selectView.frame  = CGRectMake(55, 35, 40, 4);
            weakSelf.selectView.backgroundColor = incomeColor;

        }];
        
    }
}

-(void)ChangeNameNotification:(NSNotification*)notification{
    NSArray *temp =notification.userInfo[@"typeArray"];
    BOOL isExist = NO;
    RecordTypeModel *record = [temp firstObject] ;
    if (self.expenseBut.selected == record.recordType) {
        [self selectIncomeBtn];
    }
    
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

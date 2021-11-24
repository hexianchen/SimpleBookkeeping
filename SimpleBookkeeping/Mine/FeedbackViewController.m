//
//  FeedbackViewController.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/28.
//

#import "FeedbackViewController.h"
#import "HXCMBProgressHUD.h"
@interface FeedbackViewController ()<UITextViewDelegate>{
    NSString *choseTypeName;
}
@property (weak, nonatomic) IBOutlet UIButton *errorButton;
@property (weak, nonatomic) IBOutlet UIButton *opinionButton;
@property (weak, nonatomic) IBOutlet UIButton *seekHelpButton;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *errorLogButton;
@property (weak, nonatomic) IBOutlet UITextField *contactText;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.topItem.title = @"意见反馈";
    self.contentTextView.text = @"请输入您宝贵的建议或问题，我们将及时反馈...";
    self.contentTextView.textColor = [UIColor systemGray5Color];
    self.opinionButton.selected = YES;
    choseTypeName = @"建议";
    self.opinionButton.layer.borderColor = [ExpenseColor CGColor];

}
- (IBAction)sendBtton:(UIButton *)sender {
    if ([self.contentTextView.text isEqualToString:@"请输入您宝贵的建议或问题，我们将及时反馈..."]) {
        [HXCMBProgressHUD showMessage:@"请输入您的建议或问题" ];
        return;
    }
    if (self.contactText.text ==nil) {
        [HXCMBProgressHUD showMessage:@"请输入您的联系方式" ];
        return;
    }
    //在GameScore创建一条数据，如果当前没GameScore表，则会创建GameScore表
    BmobObject  *score = [BmobObject objectWithClassName:@"Feedback"];
    //score为1200
    [score setObject:@"错误" forKey:@"errorLog"];
    //设置userName为小明

    [score setObject:choseTypeName forKey:@"typeName"];
    //设置cheatMode为NO
    [score setObject:self.contentTextView.text forKey:@"content"];
    //设置age为18
    [score setObject:self.contactText.text forKey:@"contact"];
    [HXCMBProgressHUD  showProgress:@"" ];
    //异步保存到服务器
    [score saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //创建成功后会返回objectId，updatedAt，createdAt等信息
            //创建对象成功，打印对象值
            [HXCMBProgressHUD  hide];
            NSLog(@"%@",score);
            [HXCMBProgressHUD  showMessage:@"发送成功"  afterDelayTime:2];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}
- (IBAction)tapTypeButton:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"求助"]) {
        choseTypeName = @"求助";

        self.opinionButton.selected = NO;
        self.seekHelpButton.selected = YES;
        self.errorButton.selected = NO;
        self.errorButton.layer.borderColor = [[UIColor  systemGray5Color] CGColor];
        self.seekHelpButton.layer.borderColor = [ExpenseColor CGColor];
        self.opinionButton.layer.borderColor = [[UIColor  systemGray5Color] CGColor];
    }else if ([sender.titleLabel.text isEqualToString:@"出错"]){
        choseTypeName = @"出错";

        self.opinionButton.selected = NO;
        self.seekHelpButton.selected = NO;
        self.errorButton.selected = YES;
        self.errorButton.layer.borderColor = [ExpenseColor CGColor];
        self.seekHelpButton.layer.borderColor = [[UIColor  systemGray5Color] CGColor];
        self.opinionButton.layer.borderColor = [[UIColor  systemGray5Color] CGColor];
    }else{
        choseTypeName = @"建议";
        self.opinionButton.selected = YES;
        self.seekHelpButton.selected = NO;
        self.errorButton.selected = NO;
        self.errorButton.layer.borderColor = [[UIColor  systemGray5Color] CGColor];
        self.seekHelpButton.layer.borderColor = [[UIColor  systemGray5Color] CGColor];
        self.opinionButton.layer.borderColor = [ExpenseColor CGColor];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.contentTextView.text = @"";
    self.contentTextView.textColor = [UIColor blackColor];
    return YES;
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

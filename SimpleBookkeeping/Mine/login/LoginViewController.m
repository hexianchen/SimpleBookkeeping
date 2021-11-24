//
//  LoginViewController.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/22.
//

#import "LoginViewController.h"
#import <Masonry/Masonry.h>
#import "HXCMBProgressHUD.h"
#import "UserDataModel.h"
#import "HumanBooksModel.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL loginOrRegister; //YES:登录 NO:注册
    BOOL passwordOrCode; //YES：密码 NO:验证码
}
@property (weak, nonatomic) IBOutlet UILabel *loginOrRegisterTypeLeble;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberText;
@property (weak, nonatomic) IBOutlet UITextField *passwordOrCodeText;
@property (weak, nonatomic) IBOutlet UIButton *switchcodeOrPasswordLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginOrRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *switchLoginOrRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    loginOrRegister = YES;
    passwordOrCode = YES;
    self.codeButton.hidden = YES;
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setBackgroundColor: [UIColor clearColor]];
    self.passwordOrCodeText.secureTextEntry = YES;

}
#pragma mark -UITextFildDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //实现该方法是需要注意view需要是继承UIControl而来的
}
- (IBAction)tapLigonOrRegisterButton:(id)sender {
    [self.passwordOrCodeText resignFirstResponder];
    [self.mobileNumberText resignFirstResponder];
    NSString * mobile =self.mobileNumberText.text;
    NSString * password =self.passwordOrCodeText.text;
    if (mobile.length != 11)
    {
        [HXCMBProgressHUD showMessage:@"请输入11位的手机号码"];
        return;
    }else{
        if (![Tool valiMobile:mobile]) {
            [Tool showError:@"请输入正确的手机号码"];
            return;
        }else{
            if (password.length<6) {
                [Tool showError: passwordOrCode?@"请输入6位数以上的密码" : @"请输入6位数的验证码"];
                return;
            }else{
                if (!passwordOrCode&&password.length>6) {
                    [Tool showError: @"请只输入6位数的验证码"];
                    return;
                }
            }
            
        }
    }
    [HXCMBProgressHUD showProgress:@""];

    if (loginOrRegister) {
        if(passwordOrCode){
            //按照密码登录
            [BmobUser loginInbackgroundWithAccount:mobile andPassword:password block:^(BmobUser *user, NSError *error) {
                [HXCMBProgressHUD hide];
                if (user) {
                    [HXCMBProgressHUD showSuccess:@"登录成功"];
                    NSLog(@"%@",user);
                    [self getDate:user];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSLog(@"%@",error);
                    [HXCMBProgressHUD showMessage:@"手机号或密码有误"];
                }
            
            }];
        }else{
            //按照验证码 登录
            [BmobUser loginInbackgroundWithMobilePhoneNumber:mobile andSMSCode:password block:^(BmobUser *user, NSError *error) {
                if (user) {
                    [HXCMBProgressHUD showSuccess:@"登录成功" ];
                    NSLog(@"%@",user);
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSLog(@"%@",error);
                    [HXCMBProgressHUD showMessage:@"手机号或验证码有误" ];
                }
            }];
        }
        
        
    }else{
        if(passwordOrCode){
            //按照密码注册
            BmobUser *bUser = [[BmobUser alloc] init];
            [bUser setUsername:[NSString stringWithFormat:@"%@%d", [Tool randomString:10],arc4random_uniform(9)]];
            [bUser setMobilePhoneNumber:mobile];
            [bUser setPassword:password];
            [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
                [HXCMBProgressHUD hide];
                if (isSuccessful){
                    [HXCMBProgressHUD showSuccess:@"注册成功" ];
                    [self first:bUser];
                    [self  tapSwitchLoginOrRegisterButton:nil];
                    NSLog(@"Sign up successfully");
                } else {
                    NSString *errorValue = error.userInfo[@"NSLocalizedDescription"];
                    if ([errorValue compare:@"already taken"]) {
                        if ([errorValue compare:@"mobilePhoneNumber"]) {
                            [HXCMBProgressHUD showMessage:@"手机号已经存在" ];
                        }
                    }else{
                        [HXCMBProgressHUD showMessage:errorValue ];
                    }

                    NSLog(@"%@",error);
                }
            }];
        }else{
            //按照验证码 注册
            [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:mobile andSMSCode:password block:^(BmobUser *user, NSError *error) {
                if (user){
                    [HXCMBProgressHUD showSuccess:@"注册成功" ];
                    [self first:user];
                    [self  tapSwitchLoginOrRegisterButton:nil];
                    NSLog(@"Sign up successfully");
                } else {
                    NSString *errorValue = error.userInfo[@"NSLocalizedDescription"];
                    if ([errorValue compare:@"already taken"]) {
                        if ([errorValue compare:@"mobilePhoneNumber"]) {
                            [HXCMBProgressHUD showMessage:@"手机号已经存在" ];
                        }
                    }else{
                        [HXCMBProgressHUD showMessage:errorValue ];
                    }

                    NSLog(@"%@",error);
                }
            }];
            
        }
    }
}
-(void) first:(BmobUser *)user{
    //在GameScore创建一条数据，如果当前没GameScore表，则会创建GameScore表
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"RecordData"];
    //异步保存到服务器
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //创建成功后会返回objectId，updatedAt，createdAt等信息
            //创建对象成功，打印对象值
            NSLog(@"%@",gameScore);
            //更新number为30
            [user setObject:gameScore.objectId forKey:@"recordId"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                NSLog(@"error %@",[error description]);
            }];
        } else if (error){
                //发生错误后的动作
            NSLog(@"%@",error);
        } else {

            NSLog(@"Unknow error");
        }
    }];
}
/// 点击切换登录或者注册按钮
/// @param sender 按钮
- (IBAction)tapSwitchLoginOrRegisterButton:(UIButton *)sender {
    [self.passwordOrCodeText resignFirstResponder];
    [self.mobileNumberText resignFirstResponder];
    loginOrRegister = !loginOrRegister;
    [self.switchcodeOrPasswordLoginButton setTitle:[ NSString stringWithFormat: @"验证码%@",loginOrRegister?@"登录":@"注册"] forState:UIControlStateNormal];
    self.loginOrRegisterTypeLeble.text = loginOrRegister?@"登录":@"注册";
    [self.switchLoginOrRegisterButton setTitle:loginOrRegister?@"没有账号？立即注册":@"已有账号？立即登录" forState:UIControlStateNormal];
    [self.loginOrRegisterButton setTitle:loginOrRegister?@"登录":@"注册" forState:UIControlStateNormal];
}

/// 点击切换密码或者验证码登录
/// @param sender 按钮
- (IBAction)switchcodeOrPasswordLoginButton:(id)sender {
    [self.passwordOrCodeText resignFirstResponder];
    [self.mobileNumberText resignFirstResponder];
    passwordOrCode = !passwordOrCode;
    if (passwordOrCode) {
        self.passwordOrCodeText.secureTextEntry = YES;
        self.passwordOrCodeText.keyboardType = UIKeyboardTypeNamePhonePad;
        self.codeButton.hidden = YES;
        [self.switchcodeOrPasswordLoginButton setTitle:[ NSString stringWithFormat: @"验证码%@",loginOrRegister?@"登录":@"注册"] forState:UIControlStateNormal];
        self.passwordOrCodeText.placeholder =  @"请输入密码";
    }else{
        self.passwordOrCodeText.keyboardType = UIKeyboardTypeDefault;
        self.passwordOrCodeText.secureTextEntry = NO;

        self.codeButton.hidden = NO;
        [self.switchcodeOrPasswordLoginButton setTitle:[ NSString stringWithFormat: @"账号、密码%@",loginOrRegister?@"登录":@"注册"] forState:UIControlStateNormal];
        self.passwordOrCodeText.placeholder =  @"请输入验证码";
    }
}
- (IBAction)tapGetCodeButton:(id)sender {
    [self messageTime];
    [self.passwordOrCodeText resignFirstResponder];
    [self.mobileNumberText resignFirstResponder];
}
- (IBAction)tapweixinLogin:(id)sender {
}
- (IBAction)tapQQLogin:(id)sender {
}


- (void)messageTime {

    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self.codeButton setTitleColor:[UIColor systemGray2Color] forState:0];
                self.codeButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationDuration:1];
                [self.codeButton setTitle:[NSString stringWithFormat:@"(%@)重新发送",strTime] forState:UIControlStateNormal];
                [self.codeButton setTitleColor:[UIColor systemGray4Color] forState:0];
                //To do
//                [UIView commitAnimations];
                self.codeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
-(void) getDate:(BmobUser *)user{
    // 从服务器获取数据
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"RecordData"];
 
    [bquery getObjectInBackgroundWithId:[user objectForKey:@"recordId"] block:^(BmobObject *object,NSError *error){
        if (error){
        //进行错误处理
        }else{
        //表里有id为0c6db13c的数据
            if (object) {
            //得到playerName和cheatMode
                NSMutableArray *temp = [NSMutableArray new];
                for (NSDictionary *dic in [object objectForKey:@"allRecord"]) {
                    [temp addObject: [[RecordModel alloc] initWithDictionary:dic ]];
                }
                //用户记账的所有数据
                [self saveUserData:temp];
                NSMutableArray *temp2 = [NSMutableArray new];
                for (NSDictionary *dic in [object objectForKey:@"allHumaBooksRecord"]) {
                    [temp2 addObject: [RecordHumanBooksModel initWitDictionary :dic ]];
                }
                HumanBooksModel *humanBooks = [[HumanBooksModel alloc] init];
                humanBooks.giftsArray = temp2;
                [Tool saveLocalData:humanBooks pathNameString:userRecordHumanBoosksPathName];
                
            }
        }
    }];
}
//从服务器获取数据后，保存到本地
- (void) saveUserData:(NSArray *)recordArray{
   
    //读取文件
    NSData *readData = [Tool readLocalDataPathString:userRecordPathName];
    UserDataModel *user =  [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[RecordModel class],[ThisDayDataModel class],[ThisMonthDataModel class],[ThisYearDataModel class],[UserDataModel class],[NSArray class],[NSDate class] ,nil] fromData:readData error:nil];
    if (user == nil) {
        user = [[UserDataModel alloc] init];
    }
    for (RecordModel *record in recordArray) {
        
        BOOL isYear = NO;
        for (ThisYearDataModel *year in user.allRecordArray) {
            if (year.recordYearDate  == [Tool getDate:record.time dateType:@"YYYY"]) {
                isYear = YES;
                BOOL isMonth = NO;
                for (ThisMonthDataModel *month in year.thisYearRecord) {
                    if (month.recordMonthDate == [Tool getDate:record.time dateType:@"MM"]) {
                        isMonth = YES;
                        BOOL isDay = NO;
                        for (ThisDayDataModel *day in month.thisMonthAllRecord) {
                            if (day.recordDayDate == [Tool getDate:record.time dateType:@"dd"]) {
                                day.recordDayDate = [Tool getDate:record.time dateType:@"dd"];
                                [day.thisDayAllRecord addObject:record];
                                isDay = YES;
                                break;
                            }
                        }
                        if (!isDay) {
                            ThisDayDataModel *dayTemp = [[ThisDayDataModel alloc] init];
                            [dayTemp.thisDayAllRecord addObject:record];
                            [month.thisMonthAllRecord addObject:dayTemp];
                        }
                    }
                }
                if (!isMonth) {
                    ThisMonthDataModel *monthTemp = [[ThisMonthDataModel alloc] init];
                    ThisDayDataModel *dayTemp = [[ThisDayDataModel alloc] init];
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
            [dayTemp.thisDayAllRecord addObject:record];
            [monthTemp.thisMonthAllRecord addObject:dayTemp];
            [yearTemp.thisYearRecord addObject:monthTemp];
            [user.allRecordArray addObject:yearTemp];
        }
    }

    //保存文件
    [Tool saveLocalData:user pathNameString:userRecordPathName];
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

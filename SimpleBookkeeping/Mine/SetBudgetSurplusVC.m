//
//  SetBudgetSurplusVC.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/27.
//

#import "SetBudgetSurplusVC.h"
#import "HXCMBProgressHUD.h"
@interface SetBudgetSurplusVC ()
@property (weak, nonatomic) IBOutlet UITextField *budgetSurplusTextField;
@property (weak, nonatomic) IBOutlet UITextField *allPropertyTextField;

@end

@implementation SetBudgetSurplusVC
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.budgetSurplusTextField resignFirstResponder];
    [self.allPropertyTextField resignFirstResponder];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
- (IBAction)tapTureButton:(UIButton *)sender {
    if (self.budgetSurplusTextField.text.length>0) {
        self.userdataModel.budgetSurplus = [self.budgetSurplusTextField.text floatValue];
        [self save];
    }
      
}
- (IBAction)TapTureAllPropertyButton:(id)sender {
    if (self.allPropertyTextField.text.length>0) {
        self.userdataModel.allProperty = [self.allPropertyTextField.text floatValue];
        [self save];
    }
}
-(void) save{
    //保存数据到本地
    [Tool saveLocalData:self.userdataModel pathNameString:userRecordPathName];
    [self.navigationController popViewControllerAnimated:YES];
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

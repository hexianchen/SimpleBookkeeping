//
//  MineDetailViewController.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/18.
//

#import "MineDetailViewController.h"
#import "UserInfoModel.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface MineDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIView *blackView ;
    UITapGestureRecognizer *tap;
    __weak IBOutlet UIView *tapView;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**属性名称*/
@property (nonatomic, strong) BmobUser *user;
/**属性名称*/
@property (nonatomic, strong) UIImagePickerController *picker;
@end

@implementation MineDetailViewController
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.topItem.title = @"我的资料";
    self.user = [BmobUser currentUser] ;
    [self rightBtnSava];
}
#pragma mark -更新用户的数据
- (void) updateUserData{
    if (![self.user isEqual:[BmobUser currentUser]]) {
        [self.user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"error %@",[error description]);
        }];
    }
}
- (void)rightBtnSava{

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame=CGRectMake(0, 0, 40, 40);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
//    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(5, 166, 5, 0)];
    [rightButton addTarget:self action:@selector(tapUpdateUserButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //解决按钮不靠左 靠右的问题.

    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    nagetiveSpacer.width = -10;//这个值可以根据自己需要自己调整

    self.navigationItem.rightBarButtonItems = @[nagetiveSpacer, rightBar];
}
-(void) tapUpdateUserButton{
    if (![self.user isEqual:[BmobUser currentUser]]) {
        [HXCMBProgressHUD showProgress:@""];
        [self.user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"error %@",[error description]);
            if (isSuccessful) {
                [HXCMBProgressHUD showMsgWithImage:@"success" imageName:@"success"];

            }else{
                [HXCMBProgressHUD showMsgWithImage:@"error" imageName:@"error"];
            }
        }];
    }
}
#pragma mark -UITableViewDelegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdentifierMineDetail"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"IdentifierMineDetail"];
    }
    NSString *titleS;
    NSString *detailS;

    switch (indexPath.row) {
        case 0:
        {
            titleS = @"头像";
            
        }
            break;
        case 1:
        {
            titleS = @"昵称";
            detailS = self.user.username;
            if(detailS ==nil ||detailS == NULL ||detailS == 0 ){
                detailS = @"请去填写";
            }
        }
            break;
        case 2:
        {
            titleS = @"性别";
            detailS = [self.user objectForKey:@"sex"];
            if(detailS ==nil ||detailS == NULL ||detailS == 0 ){
                detailS = @"请去填写";
            }
        }
            break;
        case 3:
        {
            titleS = @"生日";
            detailS = [self.user objectForKey:@"birthday"];
            if(detailS ==nil ||detailS == NULL ||detailS == 0 ){
                detailS = @"请去填写";
            }
         
        }
            break;
        case 4:
        {
            titleS = @"手机号";
            detailS = self.user.mobilePhoneNumber;
            if(detailS ==nil ||detailS == NULL ||detailS == 0 ){
                detailS = @"请去填写";
            }
        }
            break;
        default:
            break;
    }
    cell.textLabel.text = titleS;
    cell.detailTextLabel.text = detailS;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0:
        {
            self.picker = [[UIImagePickerController alloc]init];

            self.picker.view.backgroundColor = [UIColor orangeColor];

            UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;

            self.picker.sourceType = sourcheType;

            self.picker.delegate = self;

            self.picker.allowsEditing = YES;
            
            [self presentViewController:self.picker animated:YES completion:nil];

            
        }
            break;
        case 1:
        {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"用户名" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                //添加确定
            UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
                UITextField *txt = [alertVc.textFields objectAtIndex:0];
                if (txt.text == nil) {
                    [HXCMBProgressHUD showMessage:@"请输入昵称" ];
                }else{
                    weakSelf.user.username = txt.text;
                    [weakSelf.tableView reloadData];
                }

            }];
            //设置`确定`按钮的颜色
            [sureBtn setValue:ExpenseColor forKey:@"titleTextColor"];
            [cancelBtn setValue:[UIColor grayColor] forKey:@"titleTextColor"];
            //将action添加到控制器
            [alertVc addAction:cancelBtn];
            [alertVc addAction :sureBtn];
            [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                
                textField.text = weakSelf.user.username;
                textField.borderStyle = UITextBorderStyleNone;
                
            }];
            //展示
            [self presentViewController:alertVc animated:YES completion:nil];
        }
            break;
        case 2:
        {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                //添加确定
            UIAlertAction *manBtn = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
                [weakSelf.user setObject:@"男" forKey:@"sex"];
                [weakSelf.tableView reloadData];
            }];
            UIAlertAction *womanBtn = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
                [weakSelf.user setObject:@"女" forKey:@"sex"];
                [weakSelf.tableView reloadData];
            }];
            //设置`确定`按钮的颜色
            [cancelBtn setValue:[UIColor grayColor] forKey:@"titleTextColor"];
            [manBtn setValue:[UIColor blackColor] forKey:@"titleTextColor"];
            [womanBtn setValue:[UIColor blackColor] forKey:@"titleTextColor"];
            //将action添加到控制器
            [alertVc addAction :manBtn];
            [alertVc addAction :womanBtn];
            [alertVc addAction:cancelBtn];
            //展示
            [self presentViewController:alertVc animated:YES completion:nil];
        }
            break;
        case 3:
        {
            [self.view insertSubview:self.tableView belowSubview:self.dataView];
            [self.view bringSubviewToFront:self.dataView];
            [self.view bringSubviewToFront:tapView];
            if([self.user objectForKey:@"birthday"]){
                self.datePicker.date = [TimeTool stringToDate:[self.user objectForKey:@"birthday"] typeString:@"yyyy-MM-dd" ];
            }
            [tapView addGestureRecognizer:({
                tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapdDismiss)];
                tap;
            })];

        }
            break;
        case 4:
        {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"手机号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                //添加确定
            UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
                UITextField *txt = [alertVc.textFields objectAtIndex:0];
                if (txt.text == nil) {
                    [HXCMBProgressHUD showMessage:@"请输入手机号" ];
                }else if (![Tool valiMobile:txt.text]){
                    [HXCMBProgressHUD showMessage:@"请输入正确的手机号"];
                }else {
                    weakSelf.user.mobilePhoneNumber = txt.text;
                    [weakSelf.tableView reloadData];
                }

            }];
            //设置`确定`按钮的颜色
            [sureBtn setValue:ExpenseColor forKey:@"titleTextColor"];
            [cancelBtn setValue:[UIColor grayColor] forKey:@"titleTextColor"];
            //将action添加到控制器
            [alertVc addAction:cancelBtn];
            [alertVc addAction :sureBtn];
            [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = weakSelf.user.username;
                textField.borderStyle = UITextBorderStyleNone;
            }];
            //展示
            [self presentViewController:alertVc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
   

}

-(void) tapdDismiss
{
    [self.view sendSubviewToBack:self.dataView];
    [self.view sendSubviewToBack:tapView];
    [tapView removeGestureRecognizer:tap];


}

- (IBAction)datePickerChange:(UIDatePicker *)sender {
}
- (IBAction)LogOut:(UIButton *)sender {
 
}
- (IBAction)tureORcancel:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        [self.user setObject:[TimeTool dateToString:self.datePicker.date typeString:@"yyyy-MM-dd"] forKey:@"birthday"];
        [self.tableView reloadData];
    }
    [self tapdDismiss];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    // 获取用户拍摄的是照片还是视频

       NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];

       

       // 判断获取类型：图片，并且是刚拍摄的照片

       if ([mediaType isEqualToString:(NSString *)kUTTypeImage]

           && picker.sourceType ==UIImagePickerControllerSourceTypeCamera || picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)

       {

           UIImage *theImage =nil;

           // 判断，图片是否允许修改

           if ([picker allowsEditing])

           {

               // 获取用户编辑之后的图像

               theImage = [info objectForKey:UIImagePickerControllerEditedImage];

          

           }else {

               // 获取原始的照片

               theImage = [info objectForKey:UIImagePickerControllerOriginalImage];

           }

           // 保存图片到相册中

           UIImageWriteToSavedPhotosAlbum(theImage,self,nil,nil);

       

       }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//判断获取类型：视频，并且是刚拍摄的视频

           

           //获取视频文件的url

           NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];

           

           //创建ALAssetsLibrary对象并将视频保存到媒体库

           ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];

           // 将视频保存到相册中

           [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL

                                             completionBlock:^(NSURL *assetURL,NSError *error)

            {

                // 如果没有错误，显示保存成功。

                if (!error)

                {

                    NSLog(@"视频保存成功！");

               

                }else {

                    

                    NSLog(@"保存视频出现错误：%@", error);

                }

            }];

       }

       // 隐藏UIImagePickerController

    [self.picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.picker dismissViewControllerAnimated:YES completion:nil];

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

//
//  MBProgressHUD+JD.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/23.
//

#import "MBProgressHUD+JD.h"

@implementation MBProgressHUD (JD)

/**
 *  =======显示信息
 *  @param text 信息内容
 *  @param icon 图标
 */
+ (void)show:(NSString *)text icon:(NSString *)icon
{
     
    UIView    *view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;

    hud.label.textColor = [UIColor grayColor];
    //hud.bezelView.style = MBProgressHUDBackgroundStyleSolidCo;
    hud.label.font = [UIFont systemFontOfSize:17.0];
    hud.userInteractionEnabled= NO;
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: icon]];  // 设置图片
    hud.bezelView.backgroundColor = [UIColor whiteColor];    //背景颜色
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}

/**
 *  =======显示
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success
{
    [self show:success icon:@"success.png"];
}

/**
 *  =======显示错误信息
 */
+ (void)showError:(NSString *)error
{
    [self show:error icon:@"error.png"];

}
/**
 *  显示提示 + 菊花
 *  @param message 信息内容
 *  @return 直接返回一个MBProgressHUD， 需要手动关闭(  ?
 */

/**
 *  显示一些信息
 *  @param message 信息内容
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
  
    
    return hud;
}


+ (void)hideHUDForView
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    
    [self hideHUDForView:view animated:YES];
}

@end

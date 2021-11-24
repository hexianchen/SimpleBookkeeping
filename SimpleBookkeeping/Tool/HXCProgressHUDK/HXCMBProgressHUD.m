//
//  HXCMBProgressHUD.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/23.
//

#import "HXCMBProgressHUD.h"

@implementation HXCMBProgressHUD


+(instancetype)shareinstance{
    
    static HXCMBProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HXCMBProgressHUD alloc] init];
    });
    
    return instance;
    
}

+(void)show:(NSString *)msg  mode:(HXCMBProgressMode *)myMode{
    [self show:msg  mode:myMode customImgView:nil];
}

+(void)show:(NSString *)msg  mode:(HXCMBProgressMode *)myMode customImgView:(UIImageView *)customImgView{

    //如果已有弹框，先消失
    if ([HXCMBProgressHUD shareinstance].hud != nil) {
        [[HXCMBProgressHUD shareinstance].hud hideAnimated:YES];
        [HXCMBProgressHUD shareinstance].hud = nil;
    }
    
    //4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [[Tool getCurrentWindowVC].view endEditing:YES];
    }
    
    [HXCMBProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:[Tool getCurrentWindowVC].view animated:YES];
      
    //是否设置黑色背景，这两句配合使用
    [HXCMBProgressHUD shareinstance].hud.bezelView.color = [UIColor blackColor];
//    [HXCMBProgressHUD shareinstance].hud.contentColor = [UIColor whiteColor];
    
    [[HXCMBProgressHUD shareinstance].hud setMargin:10];
    
    [[HXCMBProgressHUD shareinstance].hud setRemoveFromSuperViewOnHide:YES];
    [HXCMBProgressHUD shareinstance].hud.detailsLabel.text = msg;

    [HXCMBProgressHUD shareinstance].hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    switch ((NSInteger)myMode) {
        case HXCMBProgressModeOnlyText:
            [HXCMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
            break;

        case HXCMBProgressModeLoading:
            [HXCMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;

        case HXCMBProgressModeCircle:{
            [HXCMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
            CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            [[HXCMBProgressHUD shareinstance].hud setMargin:50];
            animation.toValue = [NSNumber numberWithFloat:M_PI*2];
            animation.duration = 1.0;
            animation.repeatCount = 100;
            [img.layer addAnimation:animation forKey:nil];
            [HXCMBProgressHUD shareinstance].hud.customView = img;
            [HXCMBProgressHUD shareinstance].hud.customView.frame = CGRectMake(0, 0, 100, 100);
            
            
            break;
        }
        case HXCMBProgressModeCustomerImage:
            [HXCMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [HXCMBProgressHUD shareinstance].hud.customView = customImgView;
            break;

        case HXCMBProgressModeCustomAnimation:
            //这里设置动画的背景色
            [HXCMBProgressHUD shareinstance].hud.bezelView.color = [UIColor yellowColor];
            
            
            [HXCMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [HXCMBProgressHUD shareinstance].hud.customView = customImgView;
            
            break;

        case HXCMBProgressModeSuccess:
            [HXCMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [HXCMBProgressHUD shareinstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
            break;

        default:
            break;
    }
    
    
    
}
    

+(void)hide{
    if ([HXCMBProgressHUD shareinstance].hud != nil) {
        [[HXCMBProgressHUD shareinstance].hud hideAnimated:YES];
    }
}


+(void)showMessage:(NSString *)msg {
    [self show:msg  mode:HXCMBProgressModeOnlyText];
    [[HXCMBProgressHUD shareinstance].hud hideAnimated:YES afterDelay:3.0];
}



+(void)showMessage:(NSString *)msg  afterDelayTime:(NSInteger)delay{
    [self show:msg  mode:HXCMBProgressModeOnlyText];
    [[HXCMBProgressHUD shareinstance].hud hideAnimated:YES afterDelay:delay];
}

+(void)showSuccess:(NSString *)msg {
    [self show:msg  mode:HXCMBProgressModeSuccess];
    [[HXCMBProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
    
}

+(void)showMsgWithImage:(NSString *)msg imageName:(NSString *)imageName {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:msg  mode:HXCMBProgressModeCustomerImage customImgView:img];
    [[HXCMBProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
}


+(void)showProgress:(NSString *)msg {
    [self show:msg  mode:HXCMBProgressModeLoading];
}

+(MBProgressHUD *)showProgressCircle:(NSString *)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[Tool getCurrentWindowVC].view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.detailsLabel.text = msg;
    return hud;
    
    
}

+(void)showProgressCircleNoValue:(NSString *)msg {
    [self show:msg  mode:HXCMBProgressModeCircle];
    
}


+(void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg  mode:HXCMBProgressModeOnlyText];
    [[HXCMBProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
    
}

+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry {
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg  mode:HXCMBProgressModeCustomAnimation customImgView:showImageView];
    

}

@end

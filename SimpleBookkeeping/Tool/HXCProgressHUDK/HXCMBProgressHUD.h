//
//  HXCMBProgressHUD.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/23.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HXCMBProgressMode){
    HXCMBProgressModeOnlyText,           //文字
    HXCMBProgressModeLoading,               //加载菊花
    HXCMBProgressModeCircle,                //加载环形
    HXCMBProgressModeCircleLoading,         //加载圆形-要处理进度值
    HXCMBProgressModeCustomAnimation,       //自定义加载动画（序列帧实现）
    HXCMBProgressModeSuccess,                //成功
    HXCMBProgressModeCustomerImage           //自定义图片
    
};


@interface HXCMBProgressHUD : NSObject




/*===============================   属性   ================================================*/

@property (nonatomic,strong) MBProgressHUD  *hud;


/*=============================  本类自己调用 方法   =====================================*/

+(instancetype)shareinstance;

//显示
+(void)show:(NSString *)msg  mode:(HXCMBProgressMode *)myMode;


/*=========================  自己可调用 方法   ================================*/

//显示提示（1秒后消失）
+(void)showMessage:(NSString *)msg ;

//显示提示（N秒后消失）
+(void)showMessage:(NSString *)msg  afterDelayTime:(NSInteger)delay;

//在最上层显示 - 不需要指定showview
+(void)showMsgWithoutView:(NSString *)msg;


//显示进度(菊花)
+(void)showProgress:(NSString *)msg ;

//显示进度(环形)
+(void)showProgressCircleNoValue:(NSString *)msg  ;

//显示进度(转圈-要处理数据加载进度)
+(MBProgressHUD *)showProgressCircle:(NSString *)msg ;

//显示成功提示
+(void)showSuccess:(NSString *)msg ;

//显示提示、带静态图片，比如失败，用失败图片即可，警告用警告图片等
+(void)showMsgWithImage:(NSString *)msg imageName:(NSString *)imageName ;

//显示自定义动画(自定义动画序列帧  找UI做就可以了)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry ;

//隐藏
+(void)hide;

@end

NS_ASSUME_NONNULL_END

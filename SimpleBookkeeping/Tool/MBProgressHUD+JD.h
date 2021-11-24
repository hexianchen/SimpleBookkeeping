//
//  MBProgressHUD+JD.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/23.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (JD)
+ (void)showSuccess:(NSString *)success;


+ (void)showError:(NSString *)error;


+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView;
@end

NS_ASSUME_NONNULL_END

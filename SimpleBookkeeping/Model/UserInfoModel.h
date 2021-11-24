//
//  UserInfoModel.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : BmobUser

/**头像*/
@property (nonatomic, strong) NSString *headName;

/**生日*/
@property (nonatomic, strong) NSString *birthday;

/**性别*/
@property (nonatomic, strong) NSString *sex;

/**qq名称*/
@property (nonatomic, strong) NSString *qq;

/**微信名称*/
@property (nonatomic, strong) NSString *weixi;

/**新浪名称*/
@property (nonatomic, strong) NSString *xinglang;
@end

NS_ASSUME_NONNULL_END

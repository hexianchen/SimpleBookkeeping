//
//  HeaderView.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/8.
//

#import <UIKit/UIKit.h>
#import "UserDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HeaderView : UIView
@property (nonatomic, assign) void (^blockSelectSetBudgetButto)(void);
-(void) setUserData:(UserDataModel *)userData;
@end

NS_ASSUME_NONNULL_END

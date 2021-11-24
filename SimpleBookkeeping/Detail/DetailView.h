//
//  DetailView.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/21.
//

#import <UIKit/UIKit.h>
#import "UserDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailView : UIView

@property (nonatomic, strong) UserDataModel *useData;
@property (nonatomic, strong) void (^tapDateBlock)(NSInteger year, NSInteger month);
@property (nonatomic, strong) void (^tapChoseTypeBlock)(BOOL choseType);
-(void) setExpense:(NSString *) expenseString income:(NSString *) incomeString choseDateYear:(NSInteger) choseYear choseDatemonth:(NSInteger) choseMonth;
@end

NS_ASSUME_NONNULL_END

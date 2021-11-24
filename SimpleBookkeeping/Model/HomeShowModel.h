//
//  HomeShowModel.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeShowModel : NSObject
/**本月支出*/
@property (nonatomic, assign) float thisMonthExpense;
/**本月收入*/
@property (nonatomic, assign) float thisMonthIncome;
/**预算*/
@property (nonatomic, assign) float budget;
/**记录的时间MM*/
@property (nonatomic, strong) NSString *recordMonthDate;
/**本月所有数据*/
@property (nonatomic, strong) NSArray *thisMonthRecord;
@end
@interface HomeShowDayModel : NSObject
/**一天支出*/
@property (nonatomic, assign) float thisDayExpense;
/**一天收入*/
@property (nonatomic, assign) float thisDayIncome;
/**记录的时间MM-DD*/
@property (nonatomic, strong) NSString *recordDayDate;

/**本月所有数据*/
@property (nonatomic, strong) NSArray *thisDayRecord;
@end
NS_ASSUME_NONNULL_END

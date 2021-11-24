//
//  UserDataModel.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/15.
//

#import <Foundation/Foundation.h>
#import "RecordModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface ThisDayDataModel : NSObject<NSSecureCoding>
/**一天支出*/
@property (nonatomic, assign) float thisDayExpense;
/**一天收入*/
@property (nonatomic, assign) float thisDayIncome;
/**记录的时间DD*/
@property (nonatomic, assign) NSInteger recordDayDate;

/**一天所有数据*/
@property (nonatomic, strong) NSMutableArray <RecordModel *>*thisDayAllRecord;
@end
@interface ThisMonthDataModel : NSObject <NSSecureCoding>
/**本月支出*/
@property (nonatomic, assign) float thisMonthExpense;
/**本月收入*/
@property (nonatomic, assign) float thisMonthIncome;
/**记录的时间MM*/
@property (nonatomic, assign) NSInteger recordMonthDate;
/**本月所有数据*/
@property (nonatomic, strong) NSMutableArray <ThisDayDataModel*> *thisMonthAllRecord;

@end
@interface ThisYearDataModel : NSObject <NSSecureCoding>
/**本年支出*/
@property (nonatomic, assign) float thisYearExpense;
/**本年收入*/
@property (nonatomic, assign) float thisYearIncome;
/**记录的时间YYYY*/
@property (nonatomic, assign) NSInteger recordYearDate;
/**本月所有数据*/
@property (nonatomic, strong) NSMutableArray <ThisMonthDataModel*> *thisYearRecord;

@end

@interface UserDataModel : NSObject <NSSecureCoding>
/**所有资产*/
@property (nonatomic, assign) float allProperty;
/**预算*/
@property (nonatomic, assign) float budgetSurplus;
/**所有支出*/
@property (nonatomic, assign) float allExpense;
/**所有收入*/
@property (nonatomic, assign) float allIncome;
/**有多少条数据*/
@property (nonatomic, assign) float allRecordNumber;
/**所有数据*/
@property (nonatomic, strong) NSMutableArray <ThisYearDataModel*> *allRecordArray;
@end

NS_ASSUME_NONNULL_END

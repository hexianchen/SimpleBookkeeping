//
//  UserDataModel.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/15.
//

#import "UserDataModel.h"
@implementation ThisDayDataModel
-(id) init{
    if (self = [super init]) {
        if (self.thisDayAllRecord == nil) {
            self.thisDayAllRecord = [[NSMutableArray alloc] init];
        }
    }
    return self;
}
#pragma mark -数组排序
-(NSMutableArray *) thisDayAllRecord{
    
    [_thisDayAllRecord sortUsingComparator:^NSComparisonResult(RecordModel *obj1, RecordModel *obj2) {
        return [obj1.time compare:obj2.time];
    }];
    return _thisDayAllRecord;
}
#pragma mark -获取本天总金额的计算

-(float)thisDayExpense{
    float total = 0;
    for (RecordModel *temp in self.thisDayAllRecord) {
        if (!temp.recordType) {
            total += temp.money;
        }
    }
    _thisDayExpense = total;
    return _thisDayExpense;
    
}
-(float)thisDayIncome{
    float total = 0;
    for (RecordModel *temp in self.thisDayAllRecord) {
        if (temp.recordType) {
            total += temp.money;
        }
    }
    _thisDayIncome = total;
    return _thisDayIncome;
}
-(NSInteger) recordDayDate{
    RecordModel *temp = [ self.thisDayAllRecord lastObject];
    return [Tool getDate:temp.time dateType:@"dd"];
}
#pragma mark -NSSecureCoding 编码

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger :self.recordDayDate forKey:@"recordDayDate"];
    [coder encodeObject:self.thisDayAllRecord  forKey:@"thisDayAllRecord"];
    [coder encodeFloat:self.thisDayIncome forKey:@"thisDayIncome"];
    [coder encodeFloat:self.thisDayExpense forKey:@"thisDayExpense"];

}

- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self) {
        self.recordDayDate = [coder decodeIntegerForKey :@"recordDayDate"];
        self.thisDayAllRecord = [coder decodeObjectForKey:@"thisDayAllRecord"];
        self.thisDayIncome = [coder decodeFloatForKey:@"thisDayIncome"];
        self.thisDayExpense = [coder decodeFloatForKey:@"thisDayExpense"];
        
    }
    return self;
}
+(BOOL) supportsSecureCoding{
    return YES;
}
@end

@implementation ThisMonthDataModel
-(id) init{
    if (self = [super init]) {
        if (self.thisMonthAllRecord == nil) {
            self.thisMonthAllRecord = [[NSMutableArray alloc] init];
        }
    }
    return self;
}
#pragma mark -数组排序
-(NSMutableArray*) thisMonthAllRecord{
    [_thisMonthAllRecord sortUsingComparator:^NSComparisonResult(ThisDayDataModel *obj1, ThisDayDataModel *obj2) {
        if (obj1.recordDayDate < obj2.recordDayDate) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
        
    }];
    return _thisMonthAllRecord;
}
#pragma mark -获取本月的总金额的计算
-(float)thisMonthExpense {
    float total = 0;
    for (ThisDayDataModel *temp in self.thisMonthAllRecord) {
        total += temp.thisDayExpense;
    }
    _thisMonthExpense = total;
    return _thisMonthExpense;
    
}
-(float)thisMonthIncome {
    float total = 0;
    for (ThisDayDataModel *temp in self.thisMonthAllRecord) {
        total += temp.thisDayIncome;
    }
    _thisMonthIncome = total;
    return _thisMonthIncome;
}
-(NSInteger) recordMonthDate{
//    NSCalendar * c = [NSCalendar currentCalendar];
    RecordModel *temp = [[ self.thisMonthAllRecord lastObject].thisDayAllRecord lastObject];
    return [Tool getDate:temp.time dateType:@"MM"];
}
#pragma mark -NSSecureCoding 编码

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:self.recordMonthDate forKey:@"recordMonthDate"];
    [coder encodeObject:self.thisMonthAllRecord  forKey:@"thisMonthAllRecord"];
    [coder encodeFloat:self.thisMonthIncome forKey:@"thisMonthIncome"];
    [coder encodeFloat:self.thisMonthExpense forKey:@"thisMonthExpense"];

}
- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self) {
        self.recordMonthDate = [coder decodeIntegerForKey:@"recordMonthDate"];
        self.thisMonthAllRecord = [coder decodeObjectForKey:@"thisMonthAllRecord"];
        self.thisMonthIncome = [coder decodeFloatForKey:@"thisMonthIncome"];
        self.thisMonthExpense = [coder decodeFloatForKey:@"thisMonthExpense"];
        
    }
    return self;
}
+(BOOL) supportsSecureCoding{
    return YES;
}
@end

@implementation ThisYearDataModel
-(id) init{
    if (self = [super init]) {
        if (self.thisYearRecord == nil) {
            self.thisYearRecord = [[NSMutableArray alloc] init];
        }
    }
    return self;
}
#pragma mark -数组排序
-(NSMutableArray*) thisYearRecord{
    [_thisYearRecord sortUsingComparator:^NSComparisonResult(ThisMonthDataModel *obj1, ThisMonthDataModel *obj2) {
        return [@(obj1.recordMonthDate) compare:@(obj2.recordMonthDate)];
    }];
    return _thisYearRecord;
}
#pragma mark -NSSecureCoding 编码
- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:self.recordYearDate forKey:@"recordYearDate"];
    [coder encodeObject:self.thisYearRecord  forKey:@"thisYearRecord"];
    [coder encodeFloat:self.thisYearIncome forKey:@"thisYearIncome"];
    [coder encodeFloat:self.thisYearExpense forKey:@"thisYearExpense"];

}

- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self) {

        self.recordYearDate = [coder decodeIntegerForKey:@"recordYearDate"];
        self.thisYearRecord = [coder decodeObjectForKey:@"thisYearRecord"];
        self.thisYearIncome = [coder decodeFloatForKey:@"thisYearIncome"];
        self.thisYearExpense = [coder decodeFloatForKey:@"thisYearExpense"];
    }
    return self;
}
+(BOOL) supportsSecureCoding{
    return YES;
}
#pragma mark -获取本年的总金额的计算
-(float)thisYearExpense {
    float total = 0;
    for (ThisMonthDataModel *temp in self.thisYearRecord) {
        total += temp.thisMonthExpense;
    }
    _thisYearExpense = total;
    return _thisYearExpense;
    
}
-(float)thisYearIncome {
    float total = 0;
    for (ThisMonthDataModel *temp in self.thisYearRecord) {
        total += temp.thisMonthIncome;
    }
    _thisYearIncome = total;
    return _thisYearIncome;
}
-(NSInteger) recordYearDate{
    RecordModel *temp = [[[ self.thisYearRecord  lastObject].thisMonthAllRecord lastObject].thisDayAllRecord lastObject];
    return [Tool getDate:temp.time dateType:@"YYYY"];
}
@end

@implementation UserDataModel
-(id) init{
    if (self = [super init]) {
        if (self.allRecordArray == nil) {
            self.allRecordArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}
#pragma mark -数组排序
-(NSMutableArray*) allRecordArray{
    [_allRecordArray sortUsingComparator:^NSComparisonResult(ThisYearDataModel *obj1, ThisYearDataModel *obj2) {
        return [@(obj1.recordYearDate) compare:@(obj2.recordYearDate)];
    }];
    return _allRecordArray;
}
-(float)allExpense {
    float total = 0;
    for (ThisYearDataModel *temp in self.allRecordArray) {
        total += temp.thisYearExpense;
    }
    _allExpense = total;
    return _allExpense;
    
}
-(float)allIncome {
    float total = 0;
    for (ThisYearDataModel *temp in self.allRecordArray) {
        total += temp.thisYearIncome;
    }
    _allIncome = total;
    return _allIncome;
}
- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.allRecordArray  forKey:@"allRecordArray"];
    [coder encodeFloat:self.allIncome forKey:@"allIncome"];
    [coder encodeFloat:self.allExpense forKey:@"allExpense"];
    [coder encodeFloat:self.budgetSurplus forKey:@"budgetSurplus"];
    [coder encodeFloat:self.allProperty forKey:@"allProperty"];

}

- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self) {
        self.allRecordArray = [coder decodeObjectForKey:@"allRecordArray"];
        self.allIncome = [coder decodeFloatForKey:@"allIncome"];
        self.allExpense = [coder decodeFloatForKey:@"allExpense"];
        self.budgetSurplus = [coder decodeFloatForKey:@"budgetSurplus"];
        self.allProperty = [coder decodeFloatForKey:@"allProperty"];
    }
    return self;
}
+(BOOL) supportsSecureCoding{
    return YES;
}
@end

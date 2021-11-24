//
//  HumanBooksModel.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RecordHumanBooksModel : NSObject<NSSecureCoding>
/**名字*/
@property (nonatomic, strong) NSString *name;
/**礼的类型: give:送礼 receiving:收礼*/
@property (nonatomic, strong) NSString *giftType;
/**礼金*/
@property (nonatomic, strong) NSNumber *money;
/**事由*/
@property (nonatomic, strong) NSString *matter;
/**备注*/
@property (nonatomic, strong) NSString *remark;
/**记录的时间*/
@property (nonatomic, strong) NSDate *recordDate;

+ (nullable instancetype) initWitDictionary:(NSDictionary *)dic;
@end
@interface HumanBooksModel : NSObject<NSSecureCoding>
/**收礼总和*/
@property (nonatomic, strong) NSNumber *receivingGiftsTotal;
/**送礼总和*/
@property (nonatomic, strong) NSNumber *giveGiftsTotal;
/**收礼总数*/
@property (nonatomic, strong) NSNumber *receivingGiftsNumber;
/**送礼总数*/
@property (nonatomic, strong) NSNumber *giveGiftsNumber;
/**礼的数据*/
@property (nonatomic, strong) NSMutableArray <RecordHumanBooksModel *>*giftsArray;

@end

NS_ASSUME_NONNULL_END

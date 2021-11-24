//
//  RecordModel.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/9.
//

#import <JSONModel/JSONModel.h>


NS_ASSUME_NONNULL_BEGIN
@interface RecordTypeModel : NSObject <NSSecureCoding>
/**YES：收入，NO：支出*/
@property (nonatomic, assign) BOOL recordType;
/**类型 */
@property (nonatomic, strong) NSString   *type;
/**类型名字*/
@property (nonatomic, strong) NSString *typeName;
/**属性名称*/
@property (nonatomic, assign) NSInteger number;
/**类型icon*/
@property (nonatomic, strong) NSString *iconImg;

-(instancetype) initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dicFromObject;
@end

@interface RecordModel : RecordTypeModel
/**编号*/
@property (nonatomic, assign) double ID;
/**金额*/
@property (nonatomic, assign) float money;
/**时间*/
@property (nonatomic, strong) NSDate *time;
/**备注*/
@property (nonatomic, strong) NSString *remark;
/**时间字符串*/
@property (nonatomic, strong) NSString *timeString;

@end

NS_ASSUME_NONNULL_END

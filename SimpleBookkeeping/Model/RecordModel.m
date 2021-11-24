//
//  RecordModel.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/9.
//

#import "RecordModel.h"
#import "TimeTool.h"
@implementation RecordTypeModel
- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self) {
        self.number = [coder decodeIntegerForKey:@"number"];
        self.iconImg = [coder decodeObjectForKey:@"iconImg"];

        self.recordType = [coder decodeBoolForKey:@"recordType"];
        self.type = [coder decodeObjectForKey:@"type"];
        self.typeName = [coder decodeObjectForKey:@"typeName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:self.number forKey:@"number"];
    [coder encodeObject:self.iconImg forKey:@"iconImg"];
    [coder encodeBool:self.recordType forKey:@"recordType"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.typeName forKey:@"typeName"];
}
+(BOOL) supportsSecureCoding{
    return YES;
}
-(instancetype) initWithDictionary:(NSDictionary *)dict{
    self = [super self];
    if (self) {
        self.recordType = [dict[@"recordType"] boolValue];
        self.type = dict[@"type"];
        self.typeName = dict[@"typeName"];
        self.number = [dict[@"number"] integerValue];
        self.iconImg = dict[@"iconImg"];
    }
    return self;
}
- (NSDictionary *)dicFromObject{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.type forKey:@"type"];
    [dic setObject:self.typeName forKey:@"typeName"];
    [dic setObject:[NSNumber numberWithInteger:self.number]  forKey:@"number"];
    [dic setObject: self.iconImg forKey:@"iconImg"];
    [dic setObject:[NSNumber numberWithBool: self.recordType ] forKey:@"recordType"];
    return dic;
}
@end

@implementation RecordModel

 
/***加密*/
- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeDouble:self.ID forKey:@"ID"];
    [coder encodeInteger:self.number forKey:@"number"];
    [coder encodeObject:self.iconImg forKey:@"iconImg"];
    [coder encodeBool:self.recordType forKey:@"recordType"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.typeName forKey:@"typeName"];
    [coder encodeObject:self.remark forKey:@"remark"];
    [coder encodeFloat:self.money forKey:@"money"];
    [coder encodeObject:self.time forKey:@"time"];
    [coder encodeObject:self.timeString forKey:@"timeString"];
}
 
/**解密*/
- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self) {
        self.ID = [coder decodeDoubleForKey:@"ID"];

        self.number = [coder decodeIntegerForKey:@"number"];
        self.iconImg = [coder decodeObjectForKey:@"iconImg"];
        self.recordType = [coder decodeBoolForKey:@"recordType"];
        self.type = [coder decodeObjectForKey:@"type"];
        self.typeName = [coder decodeObjectForKey:@"typeName"];
        self.remark = [coder decodeObjectForKey:@"remark"];
        self.money = [coder decodeFloatForKey:@"money"];
        self.time = [coder decodeObjectForKey:@"time"];
        self.timeString =[coder decodeObjectForKey:@"timeString"];
    }
    return self;
}
+(BOOL) supportsSecureCoding{
    return YES;
}
-(NSString *) timeString{
    if (_timeString==nil) {
        _timeString = @"";
        return _timeString;
    }
    return [NSString stringWithFormat:@"%ld:%ld",[Tool getDate:_time dateType:@"HH"],[Tool getDate:_time dateType:@"mm"]];
    
}
-(NSString *)remark{
    if (_remark == nil) {
        _remark = @"";
        return _remark;
    }
    return _remark;

}
- (NSDictionary *)dicFromObject{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.type forKey:@"type"];
    [dic setObject:self.remark forKey:@"remark"];
    [dic setObject:self.typeName forKey:@"typeName"];
    [dic setObject: [TimeTool dateToString:self.time] forKey:@"time"];
    [dic setObject:[NSNumber numberWithFloat: self.money ] forKey:@"money"];
    [dic setObject:self.timeString forKey:@"timeString"];
    [dic setObject:[NSNumber numberWithBool: self.recordType] forKey:@"recordType"];
    [dic setObject:[NSNumber numberWithInteger: self.number] forKey:@"number"];
    [dic setObject:  self.iconImg forKey:@"iconImg"];
    [dic setObject:[NSNumber numberWithDouble: self.ID ] forKey:@"ID"];

    return dic;
}
-(instancetype) initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.type = dict[@"type"];
        self.remark = dict[@"remark"];
        self.typeName = dict[@"typeName"];
        self.time = [TimeTool stringToDate:dict[@"time"]];
        self.money = [dict[@"money"] floatValue];
        self.timeString = dict[@"timeString"];
        self.recordType = [dict[@"recordType"] boolValue] ;
        self.number = [dict[@"number"] integerValue];
        self.iconImg = dict[@"iconImg"];
        self.ID = [dict[@"ID"] doubleValue];

        
    }
    return self;
}
@end


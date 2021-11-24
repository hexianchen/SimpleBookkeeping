//
//  HumanBooksModel.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/31.
//

#import "HumanBooksModel.h"
#import "TimeTool.h"
@implementation RecordHumanBooksModel
+ (nullable  instancetype) initWitDictionary:(NSDictionary *)dic{
    return [[RecordHumanBooksModel alloc] initWitDictionary:dic];
}
- (nullable instancetype) initWitDictionary:(NSDictionary *)dic{
    self =[ super init];
    if (self) {
        self.name = dic[@"name"];
        self.giftType = dic[@"giftType"];
        self.money = dic[@"money"];
        self.matter = dic[@"matter"];
        self.remark = dic[@"remark"];
        self.recordDate = [TimeTool stringToDate: dic[@"recordDate"]];
    }
    return self;
}
- (nullable instancetype) initWithCoder:(NSCoder *)coder{
    self =[ super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.giftType = [coder decodeObjectForKey :@"giftType"];
        self.money = [coder decodeObjectForKey:@"money"];
        self.matter = [coder decodeObjectForKey:@"matter"];
        self.remark = [coder decodeObjectForKey:@"remark"];
        self.recordDate = [coder decodeObjectForKey:@"recordDate"];
    }
    return self;
}
-(void) encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.giftType forKey:@"giftType"];
    [coder encodeObject:self.money forKey:@"money"];
    [coder encodeObject:self.matter forKey:@"matter"];
    [coder encodeObject:self.remark forKey:@"remark"];
    [coder encodeObject:self.recordDate forKey:@"recordDate"];

}
+(BOOL) supportsSecureCoding{
    return YES;
}
@end

@implementation HumanBooksModel
-(instancetype) init{
    self = [super init];
    if (self) {
        self.giftsArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (nullable instancetype) initWithCoder:(NSCoder *)coder{
    self =[ super init];
    if (self) {
        self.giftsArray = [coder decodeObjectForKey:@"giftsArray"];
        self.giveGiftsTotal = [coder decodeObjectForKey :@"giveGiftsTotal"];
        self.receivingGiftsTotal = [coder decodeObjectForKey:@"receivingGiftsTotal"];
        self.giveGiftsNumber = [coder decodeObjectForKey:@"giveGiftsNumber"];
        self.receivingGiftsNumber = [coder decodeObjectForKey:@"receivingGiftsNumber"];
    }
    return self;
}
-(void) encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.giftsArray forKey:@"giftsArray"];
    [coder encodeObject:self.giveGiftsTotal forKey:@"giveGiftsTotal"];
    [coder encodeObject:self.receivingGiftsTotal forKey:@"receivingGiftsTotal"];
    [coder encodeObject:self.giveGiftsNumber forKey:@"giveGiftsNumber"];
    [coder encodeObject:self.receivingGiftsNumber forKey:@"receivingGiftsNumber"];
}
+(BOOL) supportsSecureCoding{
    return YES;
}
-(NSNumber *) giveGiftsTotal{
    float total = 0;
    for (RecordHumanBooksModel *tempR in self.giftsArray) {
        if ([tempR.giftType isEqualToString:@"give"]) {
            total  +=[tempR.money floatValue];
        }
    }
    return [NSNumber numberWithFloat:total];
}
-(NSNumber *) receivingGiftsTotal{
    float total = 0;
    for (RecordHumanBooksModel *tempR in self.giftsArray) {
        if ([tempR.giftType isEqualToString:@"receiving"]) {
            total  +=[tempR.money floatValue];
        }
    }
    return [NSNumber numberWithFloat:total];
}
-(NSNumber *) giveGiftsNumber{
    int total = 0;
    for (RecordHumanBooksModel *tempR in self.giftsArray) {
        if ([tempR.giftType isEqualToString:@"give"]) {
            total  +=1;
        }
    }
    return [NSNumber numberWithInt:total];
}
-(NSNumber *) receivingGiftsNumber{
    int total = 0;
    for (RecordHumanBooksModel *tempR in self.giftsArray) {
        if ([tempR.giftType isEqualToString:@"receiving"]) {
            total  +=1;
        }
    }
    return [NSNumber numberWithInt:total];
}
@end

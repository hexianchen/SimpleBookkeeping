//
//  TimeTool.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeTool : NSObject
+ (NSString *) dateToString:(NSDate *)dateTemp;
+ (NSString *) dateToString:(NSDate *)dateTemp typeString:(NSString *)type;

+ (NSDate *) stringToDate:(NSString *) dateString;
+ (NSDate *) stringToDate:(NSString *) dateString typeString:(NSString *)type;
@end

NS_ASSUME_NONNULL_END

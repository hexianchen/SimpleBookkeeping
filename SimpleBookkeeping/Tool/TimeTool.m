//
//  TimeTool.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/25.
//

#import "TimeTool.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@implementation TimeTool


+ (NSString *) dateToString:(NSDate *)dateTemp{
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 
    NSString *dateString = [formatter stringFromDate:dateTemp];
    
    return dateString;

}
+ (NSString *) dateToString:(NSDate *)dateTemp typeString:(NSString *)type{
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:type];
 
    NSString *dateString = [formatter stringFromDate:dateTemp];
    
    return dateString;

}
+ (NSDate *) stringToDate:(NSString *) dateString{
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 设置为UTC时区
    // 这里如果不设置为UTC时区，会把要转换的时间字符串定为当前时区的时间（东八区）转换为UTC时区的时间
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    // 要转换的日期字符串
    NSDate *someDay = [formatter dateFromString:dateString];
    return someDay;
}
+ (NSDate *) stringToDate:(NSString *) dateString typeString:(NSString *)type{
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:type];
    // 设置为UTC时区
    // 这里如果不设置为UTC时区，会把要转换的时间字符串定为当前时区的时间（东八区）转换为UTC时区的时间
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    // 要转换的日期字符串
    NSDate *someDay = [formatter dateFromString:dateString];
    return someDay;
}
@end

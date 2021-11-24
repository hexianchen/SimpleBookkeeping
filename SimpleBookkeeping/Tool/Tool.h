//
//  Tool.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/13.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject
/// 从NSUserDefaults 取值
/// @param key 健值
+ (id)getValue:(NSString *)key;
 
/// 在 NSUserDefaults 中 存值
/// @param value 数据
/// @param key 健值
+ (void)setValue:(id)value forKey:(NSString *)key;
 
/// 从 NSUserDefaults 中删除
/// @param key 健值
+ (void )removeValue:(NSString *)key;

/// Description 写入一个字典数组
/// @param writeArray 需要写入的数组
/// @param plistName plist文件的名字
+ (BOOL) writeToURL:(NSArray *)writeArray plistName:(NSString *)plistName;
/// 传入时间和类型
/// @param tempDate 需要获取的时间
/// @param type 类型 YYYY-MM-dd hh:mm”
+ (NSInteger ) getDate:(NSDate *)tempDate dateType:(NSString *)type;

+ (BOOL)isInSameMonth:(NSDate *)date1 dat2:(NSDate *)date2;

+ (UIViewController *)getCurrentWindowVC;
+(void) showError:(NSString *) detail;
/**
 *  判断手机号是否正确
 */
+ (BOOL)valiMobile:(NSString *)mobile;

+ (NSString *)randomString:(NSInteger)number;

+(BOOL) saveLocalData:(id)object pathNameString:(NSString *) pathString;

+( void) removeDataPathString:(NSString *)pathString;

+ (NSData *) readLocalDataPathString:(NSString *)pathString;

//汉字转拼音
+ (NSString *)transform:(NSString *)chinese;
@end

NS_ASSUME_NONNULL_END

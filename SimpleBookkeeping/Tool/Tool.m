//
//  Tool.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/13.
//

#import "Tool.h"
#import <Masonry/Masonry.h>
@implementation Tool
+ (id)getValue:(NSString *)key
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    return [userDef objectForKey:key];
}

+ (void)setValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:value forKey:key];
    [userDef synchronize];
}

+ (void )removeValue:(NSString *)key
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef removeObjectForKey:key];
    [userDef synchronize];
}

+ (NSString *) getfilePatch:(NSString *)plistName{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePatch = [path stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.plist",plistName]];
    return filePatch;
}

/// Description 写入一个字典数组
/// @param writeArray 需要写入的数组
/// @param plistName plist文件的名字
+ (BOOL) writeToURL:(NSArray *)writeArray plistName:(NSString *)plistName{
 
    NSString *cachePatch =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *fileMeanger = [NSFileManager defaultManager];
    
    //创建文件夹
    NSString *dataPath = [cachePatch stringByAppendingPathComponent:@"userData"];
    NSError *creatError;
    [fileMeanger createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&creatError];
    
    //创建文件
    NSString *listDataPath = [dataPath stringByAppendingPathComponent:@"userRecordList"];
    
    //保存文件
    NSData *listData = [@"abc"  dataUsingEncoding:NSUTF8StringEncoding];
    BOOL  isSave = [fileMeanger createFileAtPath:listDataPath contents:listData attributes:nil];
    
    //查询文件是否存在
    BOOL fileExist = [fileMeanger fileExistsAtPath:listDataPath];
    
    //删除文件
    if (fileExist) {
        [fileMeanger removeItemAtPath:listDataPath error:nil];
    }
    NSFileHandle *fileHandle =[NSFileHandle fileHandleForUpdatingAtPath:listDataPath ];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[@"dsdd" dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    [fileHandle synchronizeFile];
    [fileHandle closeFile];
    
    
    return isSave;
    
}

/// 传入时间和类型
/// @param tempDate 需要获取的时间
/// @param type 类型 YYYY-MM-dd hh:mm”
+ (NSInteger ) getDate:(NSDate *)tempDate dateType:(NSString *)type {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
     
    [formatter setDateFormat:type];
    NSInteger current=[[formatter stringFromDate:tempDate] integerValue];
    return current;
}

/**
 是否属于同一天判断

 @param time1 time1
 @param time2 time2
 @return 同一天为真，否则为假
 */
+ (BOOL)isInSameDay:(int64_t)time1 time2:(int64_t)time2
{
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time1];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time2];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;

    NSDateComponents *nowCmps = [calendar components:unit fromDate:date1];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date2];

     return nowCmps.day == selfCmps.day && nowCmps.month == selfCmps.month && nowCmps.year == selfCmps.year;
}
///  是否属于同一月
/// @param date1 第一
/// @param date2 dier
+ (BOOL)isInSameMonth:(NSDate *)date1 dat2:(NSDate *)date2
{
 
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMonth | NSCalendarUnitYear;

    NSDateComponents *nowCmps = [calendar components:unit fromDate:date1];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date2];

    return (nowCmps.year == selfCmps.year)&&(nowCmps.month == selfCmps.month);
}
//获取当前屏幕显示的viewcontroller

+(UIViewController *)getCurrentWindowVC

{
    UIViewController *result = nil;
         
    NSArray *windowAs = [UIApplication sharedApplication].windows;
    UIWindow * window = [windowAs firstObject];

    if (window.windowLevel != UIWindowLevelNormal)

    {

        NSArray *windows = [[UIApplication sharedApplication] windows];

        for(UIWindow * tempWindow in windows)

        {

            if (tempWindow.windowLevel == UIWindowLevelNormal)

            {

                window = tempWindow;

                break;

            }

        }

    }
    UIView *frontView = [[window subviews] objectAtIndex:0];

      id nextResponder = [frontView nextResponder];

      if ([nextResponder isKindOfClass:[UIViewController class]])

      {

          result = nextResponder;

      }

      else

      {

          result = window.rootViewController;
          if (result.presentedViewController) {
              result = result.presentedViewController;
          }

      }

      return  result;

}
//获取当前屏幕中present出来的viewcontroller。

+ (UIViewController *)getPresentedViewController

{

    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;

    UIViewController *topVC = appRootVC;

    if (topVC.presentedViewController) {

        topVC = topVC.presentedViewController;

    }

    return topVC;

}
+(void) showError:(NSString *) detail{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
    CGSize size=[detail sizeWithAttributes:attrs];
    UIViewController *vc= [self getCurrentWindowVC];
    UILabel *title = [[UILabel alloc] init];
    title.text = detail;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor blackColor];
    title.alpha = 0.8;
    [vc.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(vc.view);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(size.width+20);
    }];
    [UIView animateWithDuration:3 animations:^{
        title.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
}

/**
 *  判断手机号是否正确
 */
+ (BOOL)valiMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        NSString * PHONE_NUM = @"^1(3[0-9]|4[5-9]|5[0123567899]|6[2567]|7[0-8]|8[0-9]|9[0123567899])[0-9]{8}$";
//        NSString * PHONE_NUM = @"^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONE_NUM];
        BOOL isMatch = [pred evaluateWithObject:mobile];
        if (isMatch) {
            return YES;
        }else{
            return NO;
        }
    }
}
/**注释:
^1匹配输入字符串开始的位置是;
第二位和第三位判断：([358][0-9]|4[579]|66|7[0135678]|9[89]) 。其中 [358][0-9]表示匹配第二位为或者或者第三位为任意数字；4[579]表示第二位为第三位为或者或者;66表示第二位为第三位为。以此类推应当明白7[0135678]和9[89]。
[0-9]{8}$表示匹配8次0到9的数字，即后8位须为数字。
若有新号段可根据注释说明添加判断
 */



/// 随机字符串
/// @param number 需要多少位
+ (NSString *)randomString:(NSInteger)number {
    
    NSString *ramdom;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i ; i ++) {
        int a = (arc4random() % 122);
        if (a > 96) {
            char c = (char)a;
            [array addObject:[NSString stringWithFormat:@"%c",c]];
            if (array.count == number) {
                break;
            }
        } else continue;
    }
    ramdom = [array componentsJoinedByString:@""];
    return ramdom;
    
}
+( void) removeDataPathString:(NSString *)pathString{
 //删除本地的数据

    //获取Caches路径
    NSString *cachePatch =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSFileManager *fileMeanger1 = [NSFileManager defaultManager];
    
    //创建文件夹
    NSString *dataPath = [cachePatch stringByAppendingPathComponent:@"userData"];
    NSError *creatError;
    
    [fileMeanger1 createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&creatError];
    
    //创建文件名称
    NSString *listDataPath = [dataPath stringByAppendingPathComponent:pathString];

    //删除文件
    BOOL fileExists = [fileMeanger1 fileExistsAtPath:listDataPath];
    if (fileExists)
    {
        NSError *err;
       [fileMeanger1 removeItemAtPath:listDataPath error:&err];
   }
}
+ (NSData *) readLocalDataPathString:(NSString *)pathString{
 //读取本地的数据

    //获取Caches路径
    NSString *cachePatch =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSFileManager *fileMeanger1 = [NSFileManager defaultManager];
    
    //创建文件夹
    NSString *dataPath = [cachePatch stringByAppendingPathComponent:@"userData"];
    NSError *creatError;
    
    [fileMeanger1 createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&creatError];
    
    //创建文件名称
    NSString *listDataPath = [dataPath stringByAppendingPathComponent:pathString];

    //读取文件
    NSData *readData = [fileMeanger1 contentsAtPath:listDataPath];
    return readData;
}

/// 保存数据到本地
/// @param object 需要写入的数据
/// @param pathString 文件的名字
+(BOOL) saveLocalData:(id)object pathNameString:(NSString *) pathString{
    //保存数据到本地
    NSString *cachePatch =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *fileMeanger = [NSFileManager defaultManager];
    
    //创建文件夹
    NSString *dataPath = [cachePatch stringByAppendingPathComponent:@"userData"];
    NSError *creatError;
    [fileMeanger createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&creatError];
    
    //创建文件名称
    NSString *listDataPath = [dataPath stringByAppendingPathComponent:pathString];
    NSError *creatError1;
//
    //保存文件
    NSData *dataArray = [NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:YES error: &creatError1];
    BOOL  isWrite = [fileMeanger createFileAtPath:listDataPath contents:dataArray attributes:nil];
    return isWrite;
}

//汉字转拼音
+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}
@end

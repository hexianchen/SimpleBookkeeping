//
//  RecordHumanBooksVC.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/31.
//

#import <UIKit/UIKit.h>
#import "HumanBooksModel.h"
@protocol RecordHumanBooksVCDalegate <NSObject>

//@required//遵守协议必须实现的方法
@optional //遵守协议 实现不实现方法都可以

-(void) tapDisMissView:(RecordHumanBooksModel *_Nonnull) recordModel;


@end
NS_ASSUME_NONNULL_BEGIN

@interface RecordHumanBooksVC : UIViewController
@property (nonatomic, weak) id<RecordHumanBooksVCDalegate>delegate;
/**属性名称*/

@end

NS_ASSUME_NONNULL_END

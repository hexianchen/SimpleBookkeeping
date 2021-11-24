//
//  ExpenseVC.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/11.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecoredEditVC : UIViewController

/**返回一个对象和需要操作的类型 choseType：1、添加 2:修改 3:删除*/
@property (nonatomic, strong) void (^backRecordBlock)(RecordModel *record, NSInteger choseTpye);
/**属性名称*/
@property (nonatomic, assign) BOOL recordType;

-(void) getTypeArray;

/**修改或者删除的数据*/
@property (nonatomic, strong) RecordModel *choseRecord;
@end

NS_ASSUME_NONNULL_END

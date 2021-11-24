//
//  DetailViewController.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/19.
//

#import <UIKit/UIKit.h>
#import "UserDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
/**属性名称*/
@property (nonatomic, strong) UserDataModel *useData;
@end

NS_ASSUME_NONNULL_END

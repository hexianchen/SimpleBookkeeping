//
//  HumanBooksViewController.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HumanBooksViewController : UIViewController

@end
@interface ShowHumanBooksModel:NSObject
/**属性名称*/
@property (nonatomic, strong) NSString *name;
/**属性名称*/
@property (nonatomic, strong) NSMutableArray *giveGiftsArray;
/**属性名称*/
@property (nonatomic, strong) NSMutableArray *receivingGiftsArray;
@end
NS_ASSUME_NONNULL_END

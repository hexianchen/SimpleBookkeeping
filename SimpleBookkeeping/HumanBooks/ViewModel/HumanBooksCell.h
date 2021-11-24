//
//  HumanBooksCell.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/31.
//

#import <UIKit/UIKit.h>
#import "HumanBooksViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HumanBooksCell : UITableViewCell
-(void) setCellData:(ShowHumanBooksModel *) showModel;
@end

NS_ASSUME_NONNULL_END

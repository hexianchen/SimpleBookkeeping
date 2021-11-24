//
//  RecordTableViewCell.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/9.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecordTableViewCell : UITableViewCell
-(void)loadThisView:(RecordModel *)data indexPath:(NSInteger)indexPath;

@end

NS_ASSUME_NONNULL_END

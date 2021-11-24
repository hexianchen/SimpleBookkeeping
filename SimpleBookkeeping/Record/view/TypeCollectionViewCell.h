//
//  TypeCollectionViewCell.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TypeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLable;

@end

NS_ASSUME_NONNULL_END

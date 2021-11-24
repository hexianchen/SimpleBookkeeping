//
//  SortManagementHeaderView.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SortManagementHeaderView : UICollectionReusableView
/**属性名称*/
@property (nonatomic, assign) BOOL recordType;
/**属性名称*/
@property (nonatomic, strong) void(^tapButton)(BOOL type);
@end

NS_ASSUME_NONNULL_END

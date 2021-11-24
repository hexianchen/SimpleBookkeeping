//
//  CommonModel.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonModel : NSObject

/**属性名称*/
@property (nonatomic, strong) NSString *title;

/**属性名称*/
@property (nonatomic, strong) NSString *detailValue;
- (instancetype) initWithTitle:(NSString *) title detailValue:(NSString *)detaiValue;

@end

NS_ASSUME_NONNULL_END

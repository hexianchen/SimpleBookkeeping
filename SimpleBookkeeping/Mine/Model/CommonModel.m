//
//  CommonModel.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/18.
//

#import "CommonModel.h"

@implementation CommonModel
-(instancetype) initWithTitle:(NSString *)title detailValue:(NSString *)detaiValue{
    self = [super init];
    if (self) {
        self.title = title;
        if (detaiValue == nil) {
            detaiValue = @"";
        }
        self.detailValue = detaiValue;
    }
    return self;
}
@end

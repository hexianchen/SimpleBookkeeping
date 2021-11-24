//
//  HXCUIButton.m
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/12.
//

#import "HXCUIButton.h"

@implementation HXCUIButton


- (void)awakeFromNib{

    [super awakeFromNib];

    [self setup];

}

- (void)setup{

    self.titleLabel.textAlignment = NSTextAlignmentCenter;

}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];

    if (self) {

        [self setup];

    }

    return self;

}

- (void)layoutSubviews{

    [super layoutSubviews];

    CGRect newframe = self.imageView.frame;

    newframe.origin.x = (self.bounds.size.width - newframe.size.width)/2.0;

    newframe.origin.y = 0;

    self.imageView.frame = newframe;

    CGRect newTitleframe = self.titleLabel.frame;

    newTitleframe.origin.x =(self.bounds.size.width - newTitleframe.size.width)/2.0;

    self.space = self.space>0? self.space:0;

    newTitleframe.origin.y = newframe.size.height+self.space;
    newTitleframe.size = CGSizeMake(newframe.size.width, newTitleframe.size.height);
    self.titleLabel.frame = newTitleframe;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

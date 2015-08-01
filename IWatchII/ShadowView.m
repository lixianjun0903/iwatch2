//
//  ShadowView.m
//  BabyHealthy
//
//  Created by xll on 14/11/24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    UIView *view = [[UIView alloc]initWithFrame:self.frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self addSubview:view];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  MyControl.m
//  IWatchII
//
//  Created by mac on 14-11-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MyControl.h"

@implementation MyControl
+(UILabel *)createLabel:(CGRect)rect Font:(float)font bgColor:(UIColor *)color Text:(NSString *)str
{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.font = [UIFont systemFontOfSize:font];
    label.backgroundColor = color;
    label.text = str;
    return label;
}
@end

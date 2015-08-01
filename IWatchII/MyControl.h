//
//  MyControl.h
//  IWatchII
//
//  Created by mac on 14-11-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyControl : NSObject
+(UILabel *)createLabel:(CGRect )rect Font:(float)font bgColor:(UIColor *)color Text:(NSString *)str;
@end

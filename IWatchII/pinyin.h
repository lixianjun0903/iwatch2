/*
 *  pinyin.h
 *  Chinese Pinyin First Letter
 *
 *  Created by George on 4/21/10.
 *  Copyright 2010 RED/SAFI. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>

@interface ChinesePinyin : NSObject {

}

+ (char)GetFirstLetter:(NSString *)string;
+ (NSString *)GetChinesePinyin:(NSString *)string;
+ (BOOL)IsValidNickName:(NSString *)string;
+ (NSComparisonResult)CompareString:(NSString *)str1 :(NSString *)str2;

@end
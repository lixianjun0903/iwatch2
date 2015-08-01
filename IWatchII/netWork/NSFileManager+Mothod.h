//
//  NSFileManager+Mothod.h
//  HttpDemo_1425
//
//  Created by zhangcheng on 14-9-23.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//
/*
类别：对已知的类进行扩展方法，类似SDwebImage
当我们添加头文件已经，对已知的类，会自动提示你对这个类添加的方法
主要用途，对于原生不会造成破坏，使用原生就可以提示出你的方法
 本类作为对NSFileManager的扩展，扩展内容为查询缓存文件的创建时间与现有时间进行对比，从而获得缓存文件是否有效
 */


#import <Foundation/Foundation.h>

@interface NSFileManager (Mothod)
//第一个参数为文件路径  第二个参数为你设定的文件超时的时间
-(BOOL)timeOutWithPath:(NSString*)path timeOut:(NSTimeInterval)time;
//清除缓存
-(void)clearCache;
@end








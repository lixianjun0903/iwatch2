//
//  NSFileManager+Mothod.m
//  HttpDemo_1425
//
//  Created by zhangcheng on 14-9-23.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "NSFileManager+Mothod.h"

@implementation NSFileManager (Mothod)
-(BOOL)timeOutWithPath:(NSString*)path timeOut:(NSTimeInterval)time{
    //先获得文件管理的指针
    NSFileManager*manager=[NSFileManager defaultManager];
    //获得文件属性
    NSDictionary*info= [manager attributesOfItemAtPath:path error:nil];
    //获得文件的创建时间
    NSDate*createDate=[info objectForKey:NSFileCreationDate];
    //获得现在时间
    NSDate*date=[NSDate date];
    
    NSTimeInterval isTime=[date timeIntervalSinceDate:createDate];
    
    if (isTime<time) {
        //缓存有效
        return YES;
    }else{
        //缓存无效
        return NO;
    }


}
//清空缓存
-(void)clearCache
{
    //获得Documents文件夹,需要注意的是大小写，模拟器不区别大小写，但是真机严格区别大小写
    NSString*path=[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    NSFileManager*manager=[NSFileManager defaultManager];
    //获取文件名
    NSArray*fileArray=[manager contentsOfDirectoryAtPath:path error:nil];
    
    //遍历的3种方式
    //第一种方式
//    for (NSString*fileName in fileArray) {
//        //删除文件
//        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,fileName] error:nil];
//        
//    }
    //第二种方式 把数组转换为枚举
//    NSEnumerator*enumerator=[fileArray objectEnumerator];
//    NSString*str;
//    while (str=[enumerator nextObject]) {
//        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,str] error:nil];
//    }
    
    //第三种方式 block 结合枚举遍历 常用于大数据遍历，不卡主线程，是单独创建一个线程进行遍历
    [fileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //反复调用  obj是遍历到哪个对象  idx角标，stop是否停止
        
        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,obj] error:nil];
        
    }];
    

}





@end

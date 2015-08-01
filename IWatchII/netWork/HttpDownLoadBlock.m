//
//  HttpDownLoadBlock.m
//  NetWorkDemo_1425
//
//  Created by zhangcheng on 14-9-22.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "HttpDownLoadBlock.h"
#import "NSFileManager+Mothod.h"
#import "MyMD5.h"
@implementation HttpDownLoadBlock
-(id)initWithStrUrl:(NSString*)str Block:(void(^)(BOOL,HttpDownLoadBlock*))a{
    if (self=[super init]) {
        self.httpDownLoad=a;
        self.strUrl=str;
        if (str.length==0) {
            if (self.httpDownLoad) {
                self.httpDownLoad(NO,self);
                
            }
            return self;
        }
        
        //文件名进行加密
        /*
         加密算法
         MD5校验
         RC4加密
         RSA加密
         sha系列
         sha-1  sha-4  sha-256
         */
        NSString*path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[MyMD5 md5:str]];
        
        NSFileManager*manager=[NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path]&&[manager timeOutWithPath:path timeOut:60*60]) {
            //文件存在，缓存有效，使用缓存
            
            self.data=[NSData dataWithContentsOfFile:path];
            [self jsonValue];
            
            
            if (self.httpDownLoad) {
                self.httpDownLoad(YES,self);
            }
            
            
        }else{
            [self requestDownLoad];
        
        }
        
    
        
        
        
    }
    return self;
}
//网络请求
-(void)requestDownLoad{
    self.myConnection=[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]] delegate:self];
}
#pragma mark 实现网络请求4个方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data=[NSMutableData dataWithCapacity:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //下载完成后需要写入本地文件
    NSString*path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[MyMD5 md5:self.strUrl]];
    
    [self.data writeToFile:path atomically:YES];
    
    
    
    [self jsonValue];
    if (self.httpDownLoad) {
        self.httpDownLoad(YES,self);
    }
    
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.httpDownLoad) {
        self.httpDownLoad(NO,self);
    }
}
-(void)jsonValue{
//解析
    id result=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSArray class]]) {
        self.dataArray=result;
    }else{
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.dataDic=result;
        }else{
        
            self.dataImage=[UIImage imageWithData:self.data];
        }
    
    }


}



@end

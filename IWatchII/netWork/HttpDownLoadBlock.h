//
//  HttpDownLoadBlock.h
//  NetWorkDemo_1425
//
//  Created by zhangcheng on 14-9-22.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpDownLoadBlock : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property(nonatomic,strong)NSURLConnection*myConnection;
@property(nonatomic,strong)NSMutableData*data;
//网络请求地址
@property(nonatomic,copy)NSString*strUrl;
//解析结果
@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)NSDictionary*dataDic;
@property(nonatomic,strong)UIImage*dataImage;

/*block*/
//block指针 也叫做函数指针，该指针指向一个函数 其中httpDownLoad是方法名称，方法名称后面的布尔值和参数是反向传值的参数
@property(nonatomic,copy)void(^httpDownLoad)(BOOL,HttpDownLoadBlock*http);

-(id)initWithStrUrl:(NSString*)str Block:(void(^)(BOOL,HttpDownLoadBlock*))a;

@end










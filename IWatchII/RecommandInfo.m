//
//  RecommandInfo.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "RecommandInfo.h"

@implementation RecommandInfo

+ (RecommandInfo *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[RecommandInfo alloc] initWithDict:dict];
}

- (NSDictionary *)GetFormatDict:(NSDictionary *)dictionary {
    NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    for (NSString *key in netDic.allKeys) {
        id target = [netDic objectForKey:key];
        if ([target isKindOfClass:[NSNull class]]) {
            [netDic removeObjectForKey:key];
        }
    }
    return netDic;
}

- (id)initWithDict:(NSDictionary *)dictionary
{
    self = [super init];
    if (self){
        NSDictionary *netDic = [self GetFormatDict:dictionary];
        self.mDict = netDic;
        [self setValuesForKeysWithDictionary:netDic];
        self.fid = [netDic objectForKey:@"id"];
        self.m_description = [netDic objectForKey:@"description"];
    }
    return self;
}

- (void)dealloc {
    self.mDict = nil;
    self.fid = nil;
    self.m_description = nil;
    self.thumb = nil;
    self.title = nil;
    self.updatetime = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"未赋值成功的key = %@", key);
}

@end

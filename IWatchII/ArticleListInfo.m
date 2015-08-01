//
//  ArticleListInfo.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-11-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ArticleListInfo.h"

@implementation ArticleListInfo

+ (ArticleListInfo *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[ArticleListInfo alloc] initWithDict:dict];
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
    self.username = nil;
    self.title = nil;
    self.thumb = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"未赋值成功的key = %@", key);
}

@end

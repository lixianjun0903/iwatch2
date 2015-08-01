//
//  BBSListInfo.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-30.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BBSListInfo.h"

@implementation BBSListInfo

+ (BBSListInfo *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[BBSListInfo alloc] initWithDict:dict];
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
//        self._id = [netDic objectForKey:@"id"];
//        if (self.avatar && self.avatar.length > 0) {
//            NSRange range = [self.avatar rangeOfString:@"http://"];
//            if (range.length == 0) {
//                self.avatar = [NSString stringWithFormat:@"%@%@",URL_HEADER, self.avatar];
//            }
//        }
    }
    return self;
}

- (void)dealloc {
    self.mDict = nil;
    self.fup = nil;
    self.fid = nil;
    self.name = nil;
    self.icon = nil;
    self.threads = nil;
    self.posts = nil;
    self.todayposts = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"未赋值成功的key = %@", key);
}

@end

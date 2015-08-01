//
//  ForumListInfo.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-30.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForumListInfo : NSObject {
    
}

@property (nonatomic, strong) NSDictionary *mDict;
@property (nonatomic, strong) NSString *attachment;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *digest;
@property (nonatomic, strong) NSString *displayorder;
@property (nonatomic, strong) NSString *lastpost;
@property (nonatomic, strong) NSString *replies;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *views;
@property (nonatomic, strong) NSString *highlight;


+ (ForumListInfo *)CreateWithDict:(NSDictionary *)dict;


@end

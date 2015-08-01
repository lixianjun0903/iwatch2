//
//  BBSListInfo.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-30.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSListInfo : NSObject {
    
}

@property (nonatomic, strong) NSDictionary *mDict;
@property (nonatomic, strong) NSString *fup;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *threads;
@property (nonatomic, strong) NSString *posts;
@property (nonatomic, strong) NSString *todayposts;

+ (BBSListInfo *)CreateWithDict:(NSDictionary *)dict;

@end

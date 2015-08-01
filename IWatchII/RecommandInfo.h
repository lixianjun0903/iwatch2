//
//  RecommandInfo.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommandInfo : NSObject {
    
}

@property (nonatomic, strong) NSDictionary *mDict;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *m_description;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *updatetime;

+ (RecommandInfo *)CreateWithDict:(NSDictionary *)dict;


@end

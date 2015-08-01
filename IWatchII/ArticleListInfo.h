//
//  ArticleListInfo.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-11-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleListInfo : NSObject {
    
}

@property (nonatomic, strong) NSDictionary *mDict;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *m_description;
@property (nonatomic, strong) NSString *inputtime;

+ (ArticleListInfo *)CreateWithDict:(NSDictionary *)dict;


@end

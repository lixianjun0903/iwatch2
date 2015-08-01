//
//  ArticleDetailViewController.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ArticleListInfo.h"

@interface ArticleDetailViewController : BaseADViewController {
    
}

@property (nonatomic, strong) NSString *mCatID;
@property (nonatomic, strong) ArticleListInfo *mInfo;
@property (nonatomic,copy)NSString *shareUrl;
@end

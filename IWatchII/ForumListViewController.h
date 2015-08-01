//
//  ForumListViewController.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "TypeSelectView.h"
#import "BBSListInfo.h"

@interface ForumListViewController : BaseADViewController<TypeSelectViewDelegate> {
    
}
@property(nonatomic,strong)NSString *bID;
@property (nonatomic, strong) BBSListInfo *mInfo;

@end

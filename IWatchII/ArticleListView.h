//
//  ArticleListView.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-11-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"
#import "ImageDownManager.h"
#import "BaseADView.h"

@interface ArticleListView : BaseADView<RefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    RefreshTableView *mTableView;
    int miPage;
    BOOL mbReload;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSString *mCatID;
@property (nonatomic, assign) UIViewController *mRootCtrl;

- (void)RefreshView:(NSString *)catid;

@end

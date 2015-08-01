//
//  ForumListView.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-30.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"
#import "BaseADView.h"
#import "ImageDownManager.h"

@interface ForumListView : BaseADView<RefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate> {
    RefreshTableView *mTableView;
    int miPage;
    UIButton *refreshBtn;
}

@property (nonatomic, assign) int miType;
@property (nonatomic, strong) NSString *mFid;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, assign) UIViewController *mRootCtrl;
@property(nonatomic,strong)NSString *bID;
//@property (nonatomic)int flag;
- (void)RefreshView:(NSString *)fid type:(int)type;

@end

//
//  SelectResultViewController.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "RefreshTableView.h"
@interface SelectResultViewController : BaseADViewController<UITableViewDataSource, UITableViewDelegate,RefreshTableViewDelegate> {
    
}


@property (nonatomic,copy)NSString *keyword;
@end

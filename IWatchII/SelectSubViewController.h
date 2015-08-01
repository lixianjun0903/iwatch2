//
//  SelectSubViewController.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"

@interface SelectSubViewController : BaseADViewController<UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic, strong) NSMutableDictionary *mDict;
@property (nonatomic, assign) int miType;

@end

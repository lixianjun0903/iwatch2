//
//  BBSTableViewCell.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"
#import "BBSListInfo.h"

@interface BBSTableViewCell : UITableViewCell {
    NetImageView *mHeadView;
    UILabel *mlbName;
    UILabel *mlbEnName;
    UILabel *mlbDesc;
}

- (void)ShowContent:(BBSListInfo *)info;

@end
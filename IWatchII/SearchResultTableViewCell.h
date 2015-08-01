//
//  SearchResultTableViewCell.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"

@interface SearchResultTableViewCell : UITableViewCell {
    NetImageView *mHeadView;
    UILabel *mlbName;
    UILabel *mlbDesc;
    UILabel *mlbPrice;
}

- (void)ShowContent:(NSDictionary *)dict;

@end

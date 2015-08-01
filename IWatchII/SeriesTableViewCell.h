//
//  SeriesTableViewCell.h
//  IWatchII
//
//  Created by mac on 14-11-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"
@interface SeriesTableViewCell : UITableViewCell
{
    NetImageView *imageView;
    UILabel *title;
    UILabel *count;
    UIImageView *rightImageView;
}
- (void)ShowContent:(NSDictionary *)dic;
@end

//
//  SeriesDetailTableViewCell.h
//  IWatchII
//
//  Created by mac on 14-11-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"
@interface SeriesDetailTableViewCell : UITableViewCell
{
    NetImageView *imageView;
    UILabel *title;
    UILabel *desc;
    UILabel *priceLab;
    UIImageView *rightImageView;
    
}
-(void)showContent:(NSDictionary *)dic;
@end

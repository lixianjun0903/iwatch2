//
//  TieZiTableViewCell.h
//  IWatchII
//
//  Created by mac on 14-11-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TieZiTableViewCell : UITableViewCell
{
    UILabel *title;
    UILabel *time;
}
-(void)config:(NSDictionary *)dic;
@end

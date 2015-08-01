//
//  ShoucangTableViewCell.h
//  IWatchII
//
//  Created by mac on 14-11-17.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownManager.h"
#import "JSON.h"
@interface ShoucangTableViewCell : UITableViewCell
{
    UILabel *title;
    UILabel *time;
}
@property(nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic, strong) ImageDownManager *mDownManager;
-(void)config:(NSDictionary *)dic;
@end

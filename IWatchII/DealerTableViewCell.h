//
//  DealerTableViewCell.h
//  IWatchII
//
//  Created by mac on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealerViewController.h"
@interface DealerTableViewCell : UITableViewCell
{
    UILabel *dealerName;
    UILabel *descLabel;
    UIButton *detailBtn;
    
    UILabel * brandName;
    UILabel *phoneNum;
    NSString *placemark;
}
-(void)showContent:(NSDictionary *)dic;
-(void)sendTitle:(NSString *)title;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)DealerViewController *delegate;
@end

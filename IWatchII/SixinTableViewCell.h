//
//  SixinTableViewCell.h
//  IWatchII
//
//  Created by xll on 14/11/26.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SixinTableViewCell : UITableViewCell
{
    UILabel *titleLabel ;
    UILabel *authorLabel;
}
-(void)config:(NSDictionary *)dic;

@end

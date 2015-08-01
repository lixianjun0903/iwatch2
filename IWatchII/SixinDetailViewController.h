//
//  SixinDetailViewController.h
//  IWatchII
//
//  Created by xll on 14/11/26.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"

@interface SixinDetailViewController : BaseADViewController
{
    UILabel *desc;
    UILabel *author;
    UILabel *title;
}
@property(nonatomic,strong)NSDictionary *dataDic;
@end

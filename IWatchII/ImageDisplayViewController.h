//
//  ImageDisplayViewController.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"

@interface ImageDisplayViewController : BaseADViewController
@property(nonatomic,strong)NSArray *picArray;
@property(nonatomic)int page;
-(void)loadPics:(int)num;
@end

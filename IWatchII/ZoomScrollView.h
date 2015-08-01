//
//  ZoomScrollView.h
//  IWatchII
//
//  Created by xll on 14/11/26.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"
@interface ZoomScrollView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) NetImageView *imageView;
@end

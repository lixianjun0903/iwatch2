//
//  ArticleScrollViewCell.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownManager.h"
#import "JSON.h"

@interface ArticleScrollViewCell : UITableViewCell<UIScrollViewDelegate> {
    UIPageControl *mPageCtrl;
    
    UIScrollView *scrollView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
-(void)loadData:(NSString *)catid refresh:(BOOL)bRefresh;
@property(nonatomic,copy)NSString *mCatID;
@property(nonatomic,strong)UIViewController *delegate;
@end

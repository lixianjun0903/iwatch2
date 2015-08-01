//
//  RefreshTableView.h
//  MicroVideo
//
//  Created by Hepburn Alex on 12-11-23.
//  Copyright (c) 2012年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreView.h"
#import "RefreshTableHeaderView.h"

@class RefreshTableView;

@protocol RefreshTableViewDelegate <NSObject>

@optional

- (void)LoadMoreList:(RefreshTableView *)sender;
- (void)ReloadList:(RefreshTableView *)sender;
- (BOOL)CanRefreshTableView:(RefreshTableView *)sender;

@end

@interface RefreshTableView : UIView<UITableViewDataSource, UITableViewDelegate> {
    LoadMoreView *mLoadMore;
    RefreshTableHeaderView *mRefreshHeader;
    UITableView *mTableView;
    int miBotOffset;
}

@property (nonatomic, assign) id<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate> delegate;
@property (nonatomic, assign) BOOL mbMoreHidden;
@property (nonatomic, assign) BOOL mbRefreshHidden;
@property (nonatomic, assign) int miBotOffset;
@property (nonatomic, assign) UITableViewCellSeparatorStyle separatorStyle;
@property (nonatomic, assign) UIColor *separatorColor;
@property (readonly) CGSize contentSize;
@property (nonatomic, assign) CGPoint contentOffset;

- (void)FinishLoading;
- (void)reloadData;

@end

//
//  LoadMoreView.h
//  Manzi
//
//  Created by wei on 12-9-22.
//  Copyright (c) 2012年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadMoreView : UIView{
	UIButton *mLoadMore;
    UILabel *mlbText;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnLoadMore;

- (void)StartLoading;
- (void)StopLoading;

@end

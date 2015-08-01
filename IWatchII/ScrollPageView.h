//
//  ScrollPageView.h
//  QingdaoBroadcastiPad
//
//  Created by Alex Hepburn on 12-8-16.
//  Copyright (c) 2012年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollPageView;

@protocol ScrollPageViewDelegate <NSObject>

- (int)NumberOfPagesInScroll:(ScrollPageView *)pageView;
- (UIView *)ScrollPage:(ScrollPageView *)pageView viewAtIndex:(NSInteger)index;

@optional
- (UIView *)ScrollPage:(ScrollPageView *)pageView ShowPage:(UIView *)view;
- (UIView *)ScrollPage:(ScrollPageView *)pageView HidePage:(UIView *)view;

@end

@interface ScrollPageView : UIView<UIScrollViewDelegate> {
    UIScrollView *mScrollView;
}

@property (nonatomic, assign) id<ScrollPageViewDelegate> delegate;
@property (nonatomic, assign) int miIndex;
@property (nonatomic, readonly) int miCount;

- (void)reloadData;

@end

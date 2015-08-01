//
//  ScrollPageView.m
//  QingdaoBroadcastiPad
//
//  Created by Alex Hepburn on 12-8-16.
//  Copyright (c) 2012年 iHope. All rights reserved.
//

#import "ScrollPageView.h"
#import "NetImageView.h"

@implementation ScrollPageView

@synthesize miIndex, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)dealloc {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    miIndex = round(scrollView.contentOffset.x/scrollView.frame.size.width);
    [self ScrollToPage:miIndex];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    for (UIView *subView in mScrollView.subviews) {
        if (subView.tag >= 100) {
            int index = subView.tag-100;
            subView.frame = CGRectMake(index*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
    }
    mScrollView.contentSize = CGSizeMake(self.miCount*self.frame.size.width, 0);
    mScrollView.contentOffset = CGPointMake(miIndex*self.frame.size.width, 0);
}

- (void)ScrollToPage:(int)index {
    @autoreleasepool {
        int iCount = self.miCount;
        for (int i = 0; i < iCount; i ++) {
            UIView *subView = (UIView *)[mScrollView viewWithTag:i+100];
            if (i >= index-1 || i < index+1) {
                if (!subView) {
                    if (delegate && [delegate respondsToSelector:@selector(ScrollPage:viewAtIndex:)]) {
                        subView = [delegate ScrollPage:self viewAtIndex:i];
                        subView.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                        subView.tag = i+100;
                        [mScrollView addSubview:subView];
                    }
                }
                else {
                    if (i == index) {
                        if (delegate && [delegate respondsToSelector:@selector(ScrollPage:ShowPage:)]) {
                            [delegate ScrollPage:self ShowPage:subView];
                        }
                    }
                    else {
                        if (delegate && [delegate respondsToSelector:@selector(ScrollPage:HidePage:)]) {
                            [delegate ScrollPage:self HidePage:subView];
                        }
                    }
                }
            }
            else {
                [subView removeFromSuperview];
            }
        }
    }
}

- (int)miCount {
    if (delegate && [delegate respondsToSelector:@selector(NumberOfPagesInScroll:)]) {
        return [delegate NumberOfPagesInScroll:self];
    }
    return 0;
}

- (void)setMiIndex:(int)index {
    miIndex = index;
    mScrollView.contentOffset = CGPointMake(miIndex*self.frame.size.width, 0);
    [self ScrollToPage:miIndex];
}

- (void)reloadData {
    @autoreleasepool {
        if (mScrollView) {
            [mScrollView removeFromSuperview];
            mScrollView = nil;
        }
    }
    mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    mScrollView.delegate = self;
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    mScrollView.pagingEnabled = YES;
    mScrollView.showsVerticalScrollIndicator = NO;
    mScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:mScrollView];
    
    mScrollView.contentSize = CGSizeMake(self.miCount*self.frame.size.width, 0);
    self.miIndex = 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

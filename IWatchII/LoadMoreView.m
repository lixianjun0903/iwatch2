//
//  LoadMoreView.m
//  Manzi
//
//  Created by wei on 12-9-22.
//  Copyright (c) 2012年 wei. All rights reserved.
//

#import "LoadMoreView.h"

@implementation LoadMoreView
@synthesize delegate, OnLoadMore;

- (void)OnLoadMoreClick {
    if (delegate && OnLoadMore) {
        [delegate performSelector:OnLoadMore withObject:self];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        mLoadMore = [UIButton buttonWithType:UIButtonTypeCustom];
        mLoadMore.frame = self.bounds;
        mLoadMore.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [mLoadMore addTarget:self action:@selector(OnLoadMoreClick) forControlEvents:UIControlEventTouchUpInside];
        [mLoadMore setBackgroundImage:[UIImage imageNamed:@"btnmore.png"] forState:UIControlStateNormal];
        mLoadMore.adjustsImageWhenHighlighted = YES;
        mLoadMore.adjustsImageWhenDisabled = YES;
        [self addSubview:mLoadMore];
        
        mlbText = [[UILabel alloc] initWithFrame:mLoadMore.bounds];
        mlbText.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        mlbText.backgroundColor = [UIColor clearColor];
        mlbText.textAlignment = UITextAlignmentCenter;
        mlbText.font = [UIFont systemFontOfSize:14];
        mlbText.textColor = [UIColor darkGrayColor];
        mlbText.shadowOffset = CGSizeMake(1, 1);
        mlbText.shadowColor = [UIColor whiteColor];
        mlbText.text = @"显示下20条";
        [mLoadMore addSubview:mlbText];
        [mlbText release];

    }
    return self;
}
- (void)StartLoading {
    mLoadMore.enabled = NO;
    mlbText.text = @"加载数据中⋯";
}

- (void)StopLoading {
    mLoadMore.enabled = YES;
    mlbText.text = @"显示下20条";
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

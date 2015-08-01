//
//  BaseADView.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-30.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADView.h"

@implementation BaseADView

@synthesize mLoadMsg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)GetInputAccessoryView {
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    inputView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(inputView.frame.size.width-50, 0, 50, inputView.frame.size.height);
    [btn setTitle:@"隐藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(OnHideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:btn];
    
    return inputView;
}

- (void)OnHideKeyboard {
    [self endEditing:NO];
}

- (void)dealloc {
    self.mLoadMsg = nil;
}

- (void)StartLoading
{
    if (mLoadView) {
        return;
    }
    mLoadView = [[MBProgressHUD alloc] initWithView:self];
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
        mLoadView.labelText = mLoadMsg;
    }
    [mLoadView bringSubviewToFront:self];
    mLoadView.dimBackground = YES;
    [self addSubview:mLoadView];
    
    [mLoadView show:YES];
}

- (void)StopLoading
{
    mLoadView.dimBackground = NO;
    [mLoadView hide:YES];
    mLoadView = nil;
}

- (void)showMsg:(NSString *)msg
{
    mLoadView = [[MBProgressHUD alloc] initWithView:self];
	[self addSubview:mLoadView];
    
	mLoadView.mode = MBProgressHUDModeCustomView;
	mLoadView.labelText = msg;
	[mLoadView show:YES];
	[mLoadView hide:YES afterDelay:1];
    mLoadView = nil;
}

@end

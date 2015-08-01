//
//  BaseADView.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-30.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseADView : UIView {
    MBProgressHUD *mLoadView;
}

@property (nonatomic, strong) NSString *mLoadMsg;

- (void)StartLoading;
- (void)StopLoading;
- (void)showMsg:(NSString *)msg;

@end
